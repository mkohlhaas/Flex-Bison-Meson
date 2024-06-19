project('2', 'c', version: '0.1', default_options: ['warning_level=3'])

flex = find_program('flex')

cc = meson.get_compiler('c')
flex_lib = cc.find_library('fl', required: true)

translate_c = custom_target(
  input: 'lexer.l',
  output: 'lex.yy.c',
  command: [flex, '@INPUT@'],
)

executable('translate', translate_c, dependencies: flex_lib, install: false)
