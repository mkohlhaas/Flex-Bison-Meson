project('1', 'c', version: '0.1', default_options: ['warning_level=3'])

flex = find_program('flex')

cc = meson.get_compiler('c')
flex_lib = cc.find_library('fl', required: true)

wc_c = custom_target(
  input: 'lexer.l',
  output: 'lex.yy.c',
  command: [flex, '@INPUT@'],
)

executable('wc', wc_c, dependencies: flex_lib, install: false)
