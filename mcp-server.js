#!/usr/bin/env node
// kaskas MCP server — Claude Desktop integration
// Zero npm deps. Raw stdio JSON-RPC (MCP 2024-11-05).
// Reads command files from ./commands/ at runtime.
// Works on Windows Store Claude Desktop (MSIX Electron = Win32 container).

'use strict';

const readline = require('readline');
const fs = require('fs');
const path = require('path');

const BASE_DIR     = path.dirname(process.argv[1] || __filename);
const COMMANDS_DIR = path.join(BASE_DIR, 'commands');
const REFS_DIR     = path.join(BASE_DIR, 'references');

// ── Command registry ──────────────────────────────────────────────────────────

const COMMANDS = [
  { name: 'review',        description: 'Analyze credit card statements — extract spend, find patterns, detect recurring' },
  { name: 'due',           description: 'Track upcoming dues, bills, subscriptions — next 30 days, risk flags' },
  { name: 'subscriptions', description: 'Detect recurring charges with high/medium/low confidence scoring' },
  { name: 'offers',        description: 'Find best PH credit card for your spending — cashback estimates, gap analysis' },
  { name: 'safe',          description: 'Utilization risk score + safe spending threshold (0-100 safety score)' },
  { name: 'export',        description: 'Export transactions/obligations as JSON, CSV, or Markdown' },
  { name: 'ocr',           description: 'Extract transaction text from images, screenshots, or receipts' },
  { name: 'pdf',           description: 'Extract transactions from PDF statements' },
  { name: 'promos',        description: 'Parse credit card promotional offers and limited-time rewards' },
  { name: 'memory',        description: 'Store and recall financial data in SQLite (persistent across sessions)' },
  { name: 'embed',         description: 'Semantic search on transaction history' },
  { name: 'insights',      description: 'Pattern analysis, anomaly detection, intelligent recommendations' },
  { name: 'llm',           description: 'Local LLM financial analysis — no external API calls' },
  { name: 'remind',        description: 'Set proactive payment reminders and smart alerts' },
  { name: 'forecast',      description: 'Spending forecasts, what-if scenarios, confidence intervals' },
];

// Reference files to inline for commands that need them
const CMD_REFS = {
  review:        ['merchant-categories.md', 'recurring-patterns.md', 'utilization-rules.md'],
  due:           [],
  subscriptions: ['recurring-patterns.md'],
  offers:        ['ph-cards.md', 'merchant-categories.md'],
  safe:          ['utilization-rules.md'],
  export:        [],
  ocr:           [],
  pdf:           [],
  promos:        [],
  memory:        [],
  embed:         ['embedding-config.md'],
  insights:      ['merchant-categories.md', 'recurring-patterns.md'],
  llm:           ['llm-config.md'],
  remind:        [],
  forecast:      ['forecast-config.md'],
};

function readFile(filePath) {
  try { return fs.readFileSync(filePath, 'utf8'); } catch (e) { return null; }
}

function loadCommand(name) {
  const cmdContent = readFile(path.join(COMMANDS_DIR, name + '.md'));
  if (!cmdContent) return null;

  const refs = CMD_REFS[name] || [];
  if (refs.length === 0) return cmdContent;

  const refParts = refs
    .map(ref => {
      const content = readFile(path.join(REFS_DIR, ref));
      return content ? `\n\n---\n## Reference: ${ref}\n\n${content}` : null;
    })
    .filter(Boolean);

  return cmdContent + refParts.join('');
}

// ── MCP prompt builders ───────────────────────────────────────────────────────

const PREAMBLE =
  'Kaskas financial skill active. Local-only. Zero external calls.\n' +
  'Output: concise, tables only, amounts in PHP, tactical recommendations.\n\n';

function buildPrompt(name) {
  const meta = COMMANDS.find(c => c.name === name);
  const instructions = loadCommand(name);

  const body = instructions
    ? PREAMBLE + instructions
    : PREAMBLE + `Run /${name} — analyze financial data and provide structured output.`;

  return {
    description: meta ? meta.description : `Run kaskas /${name}`,
    messages: [
      {
        role: 'user',
        content: { type: 'text', text: `/${name}` },
      },
      {
        role: 'assistant',
        content: { type: 'text', text: body },
      },
    ],
  };
}

// ── JSON-RPC stdio transport ──────────────────────────────────────────────────

const rl = readline.createInterface({ input: process.stdin, terminal: false });

function send(obj)          { try { process.stdout.write(JSON.stringify(obj) + '\n'); } catch (e) {} }
function reply(id, result)  { send({ jsonrpc: '2.0', id, result }); }
function err(id, code, msg) { send({ jsonrpc: '2.0', id, error: { code, message: msg } }); }

function handle(req) {
  const { id, method, params } = req;

  switch (method) {
    // ── Lifecycle ─────────────────────────────────────────────────────────────
    case 'initialize':
      reply(id, {
        protocolVersion: '2024-11-05',
        capabilities: { prompts: {} },
        serverInfo: { name: 'kaskas', version: '4.0.0' },
      });
      break;

    case 'notifications/initialized':
    case 'initialized':
      break; // Notification — no response

    // ── Prompts ───────────────────────────────────────────────────────────────
    case 'prompts/list':
      reply(id, {
        prompts: COMMANDS.map(c => ({
          name: c.name,
          description: c.description,
          arguments: [],
        })),
      });
      break;

    case 'prompts/get': {
      const name = params && params.name;
      if (!COMMANDS.find(c => c.name === name)) {
        err(id, -32602, 'Unknown prompt: ' + name);
        break;
      }
      reply(id, buildPrompt(name));
      break;
    }

    // ── Ping ─────────────────────────────────────────────────────────────────
    case 'ping':
      reply(id, {});
      break;

    default:
      if (id != null) err(id, -32601, 'Method not found: ' + method);
  }
}

rl.on('line', line => {
  line = line.trim();
  if (!line) return;
  try { handle(JSON.parse(line)); } catch (e) {}
});

process.stdin.on('end', () => process.exit(0));
process.on('uncaughtException', () => {});
process.on('unhandledRejection', () => {});
