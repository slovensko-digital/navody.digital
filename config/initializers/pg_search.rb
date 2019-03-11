PgSearch.multisearch_options = {
  using: {
    tsearch: {
      any_word: true,
      prefix: true,
      normalization: 1,
      tsvector_column: 'tsv_content'
    }
  }
}
