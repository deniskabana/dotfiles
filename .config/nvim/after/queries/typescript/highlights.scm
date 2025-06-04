;; extends

(import_specifier
  name: (identifier) @custom.import)
(import_specifier
  alias: (identifier) @custom.import)

((optional_chain) @custom.chain.delimiter
  (#set! priority 150))
