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
const DATA_DIR     = path.join(BASE_DIR, 'data');

// ── Command registry ──────────────────────────────────────────────────────────

const COMMANDS = [
  { name: 'kaskas',        description: '💰 Kaskas menu — show all commands, status, quick start guide' },
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
// Note: Most data now in JSON (data/*.json) accessed via tools
// Only config files remain as MD references
const CMD_REFS = {
  kaskas:        [],
  review:        ['utilization-rules.md'],
  due:           [],
  subscriptions: [],
  offers:        [],
  safe:          ['utilization-rules.md'],
  export:        [],
  ocr:           [],
  pdf:           [],
  promos:        [],
  memory:        [],
  embed:         ['embedding-config.md'],
  insights:      [],
  llm:           ['llm-config.md'],
  remind:        [],
  forecast:      ['forecast-config.md'],
};

function readFile(filePath) {
  try { return fs.readFileSync(filePath, 'utf8'); } catch (e) { return null; }
}

function loadJSON(filename) {
  try {
    const content = fs.readFileSync(path.join(DATA_DIR, filename), 'utf8');
    return JSON.parse(content);
  } catch (e) { return null; }
}

// ── Data search functions ─────────────────────────────────────────────────────

function searchMerchant(query) {
  const data = loadJSON('merchants.json');
  if (!data) return [];
  
  const q = query.toLowerCase();
  return data.merchants
    .filter(m => 
      m.name.toLowerCase().includes(q) ||
      m.keywords.some(k => k.includes(q)) ||
      m.category.toLowerCase().includes(q) ||
      m.subcategory.toLowerCase().includes(q)
    )
    .slice(0, 10);
}

function searchCard(filters = {}) {
  const data = loadJSON('cards.json');
  if (!data) return [];
  
  let results = data.cards;
  
  if (filters.bank) {
    results = results.filter(c => c.bank.toLowerCase().includes(filters.bank.toLowerCase()));
  }
  if (filters.category) {
    results = results.filter(c => c.categories.includes(filters.category.toLowerCase()));
  }
  if (filters.type) {
    results = results.filter(c => c.type === filters.type);
  }
  if (filters.tier) {
    results = results.filter(c => c.tier === filters.tier);
  }
  
  return results.slice(0, 10);
}

function getBestCardForCategory(category) {
  const data = loadJSON('cards.json');
  if (!data || !data.categoryBestCards) return [];
  
  return data.categoryBestCards[category.toLowerCase()] || [];
}

function getHoliday(date) {
  const data = loadJSON('calendar.json');
  if (!data) return null;
  
  const mmdd = date.slice(5); // Extract MM-DD from YYYY-MM-DD
  return data.holidays.find(h => h.date === mmdd);
}

function isPayday(day) {
  const data = loadJSON('calendar.json');
  if (!data) return false;
  
  return data.paydays.some(p => p.day === day);
}

function getSaleDates(month) {
  const data = loadJSON('calendar.json');
  if (!data) return [];
  
  if (month) {
    const mm = String(month).padStart(2, '0');
    return data.saleDates.filter(s => s.date.startsWith(mm));
  }
  return data.saleDates;
}

function isBerMonth(month) {
  const data = loadJSON('calendar.json');
  if (!data) return false;
  
  return data.berMonths.months.includes(month);
}

function searchPromo(filters = {}) {
  const data = loadJSON('promos.json');
  if (!data) return [];
  
  let results = [];
  
  if (filters.bank && data.bankPromos) {
    results = data.bankPromos.daySpecific.filter(p => 
      p.bank.toLowerCase().includes(filters.bank.toLowerCase())
    );
  }
  if (filters.merchant && data.foodPromos) {
    const food = data.foodPromos.filter(p => 
      p.chain.toLowerCase().includes(filters.merchant.toLowerCase())
    );
    results = results.concat(food);
  }
  
  return results.slice(0, 10);
}

function detectPattern(transactions) {
  const data = loadJSON('spending-patterns.json');
  if (!data) return [];
  
  // Return pattern definitions for Claude to match
  return data.patterns;
}

function getExpression(context) {
  const data = loadJSON('expressions.json');
  if (!data) return null;
  
  const expr = data.greetings.find(g => g.context === context);
  return expr ? expr.expression : null;
}

function getTerm(word) {
  const data = loadJSON('terms.json');
  if (!data) return null;
  
  const term = data.pinoyTerms.find(t => 
    t.term.toLowerCase() === word.toLowerCase()
  );
  return term;
}

function getSubscriptionServices() {
  const data = loadJSON('patterns.json');
  if (!data) return [];
  
  return data.subscriptionServices;
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
        capabilities: { prompts: {}, tools: {} },
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

    // ── Tools ─────────────────────────────────────────────────────────────────
    case 'tools/list':
      reply(id, {
        tools: [
          {
            name: 'search_merchant',
            description: 'Search for merchant category by name or keyword',
            inputSchema: {
              type: 'object',
              properties: {
                query: { type: 'string', description: 'Merchant name or keyword to search' }
              },
              required: ['query']
            }
          },
          {
            name: 'search_card',
            description: 'Search for credit cards by bank, category, or type',
            inputSchema: {
              type: 'object',
              properties: {
                bank: { type: 'string', description: 'Bank name (BDO, BPI, etc.)' },
                category: { type: 'string', description: 'Spending category (dining, groceries, travel, etc.)' },
                type: { type: 'string', enum: ['credit', 'debit'], description: 'Card type' },
                tier: { type: 'string', enum: ['classic', 'gold', 'platinum', 'signature', 'world'], description: 'Card tier' }
              }
            }
          },
          {
            name: 'get_best_card',
            description: 'Get best credit card recommendations for a spending category',
            inputSchema: {
              type: 'object',
              properties: {
                category: { type: 'string', description: 'Spending category (dining, groceries, online, fuel, travel)' }
              },
              required: ['category']
            }
          },
          {
            name: 'check_holiday',
            description: 'Check if a date is a Philippine holiday',
            inputSchema: {
              type: 'object',
              properties: {
                date: { type: 'string', description: 'Date in YYYY-MM-DD format' }
              },
              required: ['date']
            }
          },
          {
            name: 'check_payday',
            description: 'Check if a day is a typical payday',
            inputSchema: {
              type: 'object',
              properties: {
                day: { type: 'number', description: 'Day of month (1-31)' }
              },
              required: ['day']
            }
          },
          {
            name: 'get_sale_dates',
            description: 'Get e-commerce sale dates (11.11, 12.12, etc.)',
            inputSchema: {
              type: 'object',
              properties: {
                month: { type: 'number', description: 'Month number (1-12), optional' }
              }
            }
          },
          {
            name: 'check_ber_month',
            description: 'Check if a month is a Ber month (Sep-Dec Christmas season)',
            inputSchema: {
              type: 'object',
              properties: {
                month: { type: 'number', description: 'Month number (1-12)' }
              },
              required: ['month']
            }
          },
          {
            name: 'search_promo',
            description: 'Search for promos by bank or merchant',
            inputSchema: {
              type: 'object',
              properties: {
                bank: { type: 'string', description: 'Bank name' },
                merchant: { type: 'string', description: 'Merchant name' }
              }
            }
          },
          {
            name: 'get_spending_patterns',
            description: 'Get Filipino spending pattern definitions for detection',
            inputSchema: {
              type: 'object',
              properties: {}
            }
          },
          {
            name: 'get_expression',
            description: 'Get Taglish expression for a context (if taglish mode enabled)',
            inputSchema: {
              type: 'object',
              properties: {
                context: { type: 'string', description: 'Context (good_savings, overspending, due_reminder, etc.)' }
              },
              required: ['context']
            }
          },
          {
            name: 'get_term',
            description: 'Get definition of a Filipino financial term',
            inputSchema: {
              type: 'object',
              properties: {
                word: { type: 'string', description: 'Filipino term (sweldo, utang, hulog, etc.)' }
              },
              required: ['word']
            }
          },
          {
            name: 'get_subscription_services',
            description: 'Get list of known subscription services for detection',
            inputSchema: {
              type: 'object',
              properties: {}
            }
          }
        ]
      });
      break;

    case 'tools/call': {
      const toolName = params && params.name;
      const args = params && params.arguments || {};
      
      let result;
      switch (toolName) {
        case 'search_merchant':
          result = searchMerchant(args.query || '');
          break;
        case 'search_card':
          result = searchCard(args);
          break;
        case 'get_best_card':
          result = getBestCardForCategory(args.category || '');
          break;
        case 'check_holiday':
          result = getHoliday(args.date || '');
          break;
        case 'check_payday':
          result = isPayday(args.day);
          break;
        case 'get_sale_dates':
          result = getSaleDates(args.month);
          break;
        case 'check_ber_month':
          result = isBerMonth(args.month);
          break;
        case 'search_promo':
          result = searchPromo(args);
          break;
        case 'get_spending_patterns':
          result = detectPattern();
          break;
        case 'get_expression':
          result = getExpression(args.context || '');
          break;
        case 'get_term':
          result = getTerm(args.word || '');
          break;
        case 'get_subscription_services':
          result = getSubscriptionServices();
          break;
        default:
          err(id, -32602, 'Unknown tool: ' + toolName);
          return;
      }
      
      reply(id, {
        content: [{ type: 'text', text: JSON.stringify(result, null, 2) }]
      });
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
