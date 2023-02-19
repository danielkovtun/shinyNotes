# CHANGES IN SHINYNOTES VERSION 0.0.2

- Use of `dplyr::in_schema` removed for SQLite database connections to account for changes to DBI and/or `dbplyr` API.
  - The database table read and write methods now use generic `DBI` methods for constructing table identifiers, regardless of SQL flavor.
- Package data has been re-saved with version 2 to support-backwards compatible reading of serialized objects 

# CHANGES IN SHINYNOTES VERSION 0.0.1

- Initial CRAN release.
