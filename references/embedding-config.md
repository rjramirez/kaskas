# Embedding Configuration

## Model

**text-embedding-3-small**
- Dimensions: 1536
- Speed: fast
- Accuracy: high
- Cost: low

## Similarity Threshold

- **High confidence**: >0.85 similarity
- **Medium confidence**: 0.70-0.85
- **Low confidence**: <0.70

## Embedding Types

### Merchant
- Merchant names
- Vendor names
- Store names
- Used for: finding similar merchants

### Category
- Category names
- Spending types
- Used for: category clustering

### Description
- Transaction descriptions
- Notes
- Used for: semantic search

### Obligation Type
- Obligation types
- Bill names
- Used for: obligation clustering

## Clustering

**K-means clustering** for merchant grouping:
- K = auto (based on data size)
- Distance metric: cosine similarity
- Recalculate: weekly or on new data

## Search

**Vector similarity search**:
- Query embedding generated on-the-fly
- Top-K results (default K=5)
- Threshold filtering (>0.70)

## Performance

- Index: HNSW (Hierarchical Navigable Small World)
- Query time: <100ms
- Storage: ~2MB per 1000 embeddings

## Privacy

- All embeddings local
- No external API calls
- No data transmission
- User owns all vectors

Local embeddings. No tracking.
