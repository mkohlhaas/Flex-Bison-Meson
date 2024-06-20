### Project ####################################################################

project('5', 'c', version: '0.1', default_options: ['warning_level=3'])

### Flex #######################################################################

flex_prog = find_program('flex')

cc = meson.get_compiler('c')
flex_lib = cc.find_library('fl', required: true)

lexer_input = 'lexer.l'
lexer_output = 'lex.yy.c'

lexer_c = custom_target(
  input: lexer_input,
  command: [flex_prog, '@INPUT@'],
  output: lexer_output,
)

### Bison ######################################################################

bison_prog = find_program('bison')
bison_lib = cc.find_library('y', required: true)

parser_input = 'parser.y'
parser_h = 'parser.h'
parser_c = 'parser.c'

scanner_c = custom_target(
  input: parser_input,
  command: [bison_prog, f'-H@parser_h@', f'-o@parser_c@', '@INPUT@'],
  output: [parser_h, parser_c],
)

### Binary #####################################################################

executable(
  'calc',
  [lexer_c, scanner_c],
  dependencies: [flex_lib, bison_lib],
  install: false,
)
