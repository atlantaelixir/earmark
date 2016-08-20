%% 
%% This is a simple lexer that lexes lexical tokens in each line.
%% We split the input before we use the token lexer in order to be able
%% to use parallelism
%% These primitive tokens are then combined into more complex tokens by the scanner
%%    e.g.
%%
Definitions.

BT          = ` 
SINGLE      = _<
HASH        = #
SPECIAL     = {SINGLE}{BT}{HASH}
WS          = \s\t

Rules.

[{SINGLE}] : {token, {single, hd(TokenChars)}}.

{BT}+      : {token, {backticks, length(TokenChars)}}.

{HASH}|{HASH}{HASH}|{HASH}{HASH}{HASH}|{HASH}{HASH}{HASH}{HASH}|{HASH}{HASH}{HASH}{HASH}{HASH}|{HASH}{HASH}{HASH}{HASH}{HASH}{HASH}                                   : {token,{hashes, length(TokenChars)}}. 
{HASH}{HASH}{HASH}{HASH}{HASH}{HASH}{HASH}+ :  {token, {any, TokenChars}}.

[^{SPECIAL}{WS}\n]+ : {token, {any, TokenChars}}.

[{WS}]+  : {token, {ws, TokenChars}}.

Erlang code.
