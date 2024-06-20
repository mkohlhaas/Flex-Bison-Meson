project('2', 'c', version: '0.1', default_options: ['warning_level=3'])

flex = find_program('flex')

cc = meson.get_compiler('c')
flex_lib = cc.find_library('fl', required: true)

wc_c = custom_target(
  input: 'lexer.l',
  output: 'lex.yy.c',
  command: [flex, '@INPUT@'],
)

fs = import('fs')
fs.copyfile('test_files/big.txt')
fs.copyfile('test_files/hamlet.txt')
fs.copyfile('test_files/tempest.txt')

executable('wc', wc_c, dependencies: flex_lib, install: false)
