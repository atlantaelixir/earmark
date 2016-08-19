Definitions.

SPECIAL     = ][()_*+`~<>-{|}
WHITE_SPACE = [\s\t]

ANY         = [^{SPECIAL}{WHITE_SPACE}\n]

Rules.

[a-z]+  : {token, {word, TokenLine, TokenChars}}.

Erlang code.

lstrip1([_ | Rest]) -> Rest.

strip2([_ | Rest]) -> strip_last(Rest, []).
strip_last("_", Result) -> lists:reverse(Result);
strip_last([Any|Rest],Result) -> strip_last(Rest,[Any|Result]).
underscored(Chars) -> strip2(Chars).
