# /embed

Generate embeddings. Semantic search.

## Input
- Merchant names
- Transaction descriptions
- Category names
- Obligation types

## Process

1. **Generate embeddings** → local model (no API calls)
2. **Store vectors** → in SQLite (vector extension)
3. **Index** → for fast similarity search
4. **Normalize** → standardize text before embedding

## Output

**Embedding Status**
- Records embedded: X
- New embeddings: X
- Skipped: X

**Semantic Search**
- `/embed search [query]` → find similar merchants/transactions
- `/embed similar [merchant]` → find similar merchants
- `/embed cluster` → group similar transactions

## Examples

**Search:** "food delivery"
→ finds: GrabFood, Foodpanda, Zomato, etc.

**Similar:** "Jollibee"
→ finds: McDonald's, KFC, Chowking (fast food cluster)

**Cluster:** Groups transactions by semantic meaning
→ "dining" cluster: restaurants, cafes, food delivery
→ "transport" cluster: Grab, Uber, taxi, bus

## Benefits

- Find similar merchants automatically
- Detect category mismatches
- Discover spending patterns
- Improve categorization

Local only. No external API.
