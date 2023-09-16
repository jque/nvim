-- :Snek     " converts to snake_case               ('foo bar' -> 'foo_bar')
-- :Camel    " converts to CamelCase                ('foo bar' -> 'FooBar')
-- :CamelB   " converts to camelbackCase            ('foo bar' -> 'fooBar')
-- :Kebab    " converts to kebab-case               ('foo bar' -> 'foo-bar')
-- :Screm    " converts to SCREAMING_SNAKE_CASE     ('foo bar' -> 'FOO_BAR')
return {
  'nicwest/vim-camelsnek',
  config = function()
    vim.cmd('command! ConvertToSnek Snek')
    vim.cmd('command! ConvertToCamel Camel')
    vim.cmd('command! ConvertToCamelB CamelB')
    vim.cmd('command! ConvertToKebab Kebab')
    vim.cmd('command! ConvertToScrem Screm')
  end
}
