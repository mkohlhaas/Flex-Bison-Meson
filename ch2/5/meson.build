project('5', 'c', version: '0.1', default_options: ['warning_level=3'])

flex = find_program('flex')

cc = meson.get_compiler('c')
flex_lib = cc.find_library('fl', required: true)

wc_c = custom_target(
  input: 'lexer.l',
  command: [flex, '@INPUT@'],
  output: 'lex.yy.c',
)

fs = import('fs')
fs.copyfile('test_files/my_stdio.h')
fs.copyfile('test_files/test.h')

executable('wc', wc_c, dependencies: flex_lib, install: false)
