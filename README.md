jpeg
====

A ParsingGrammarExpression parser generator written in java with multiple target languages. 
Currently recursive-descent but should implement packrat algorithm.

jpeg is based on the ideas of Ford (http://pdos.csail.mit.edu/~baford/packrat/thesis/)
and extend like Warth, Douglass and Millstein described (http://www.cs.ucla.edu/~todd/research/pepm08.pdf).

TODO
====
* support left-recursion
* Action expressions
* 'current' assignment
* unordered groups
* Lazy return type creation
* unassigned rule calls
* Cross-References (maybe)
