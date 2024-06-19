project('3', 'c', version: '0.1', default_options: ['warning_level=3'])

flex_prog = find_program('flex')

cc = meson.get_compiler('c')
flex_lib = cc.find_library('fl', required: true)

calc_c = custom_target(
  input: 'lexer.l',
  command: [flex_prog, '@INPUT@'],
  output: 'lex.yy.c',
)

executable('calc', calc_c, dependencies: flex_lib, install: false)
