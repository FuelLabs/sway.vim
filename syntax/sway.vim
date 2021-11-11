" Vim syntax file
" Language:     Rust
" Maintainer:   Victor Lopez <victor.lopez@fuel.sh>
" Last Change:  Nov 11, 2021
" Forked from rust.vim

if version < 600
	syntax clear
elseif exists("b:current_syntax")
	finish
endif

" Syntax definitions {{{1
" Basic keywords {{{2
syn keyword   swayConditional match if else
syn keyword   swayRepeat for loop while
syn keyword   swayTypedef type nextgroup=rustIdentifier skipwhite skipempty
syn keyword   swayStructure struct enum nextgroup=rustIdentifier skipwhite skipempty
syn keyword   swayUnion union nextgroup=rustIdentifier skipwhite skipempty contained
syn match swayUnionContextual /\<union\_s\+\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*/ transparent contains=rustUnion
syn keyword   swayOperator    as

syn match     swayAssert      "\<assert\(\w\)*!" contained
syn match     swayPanic       "\<panic\(\w\)*!" contained
syn keyword   swayKeyword     break
syn keyword   swayKeyword     box nextgroup=rustBoxPlacement skipwhite skipempty
syn keyword   swayKeyword     continue
syn keyword   swayKeyword     extern nextgroup=rustExternCrate,rustObsoleteExternMod skipwhite skipempty
syn keyword   swayKeyword     fn nextgroup=rustFuncName skipwhite skipempty
syn keyword   swayKeyword     in impl let
syn keyword   swayKeyword     pub nextgroup=rustPubScope skipwhite skipempty
syn keyword   swayKeyword     return
syn keyword   swaySuper       super
syn keyword   swayKeyword     unsafe where
syn keyword   swayKeyword     use nextgroup=rustModPath skipwhite skipempty
" FIXME: Scoped impl's name is also fallen in this category
syn keyword   swayKeyword     mod trait nextgroup=rustIdentifier skipwhite skipempty
syn keyword   swayStorage     move mut ref static const
syn match swayDefault /\<default\ze\_s\+\(impl\|fn\|type\|const\)\>/

syn keyword   swayInvalidBareKeyword crate

syn keyword swayPubScopeCrate crate contained
syn match swayPubScopeDelim /[()]/ contained
syn match swayPubScope /([^()]*)/ contained contains=rustPubScopeDelim,rustPubScopeCrate,rustSuper,rustModPath,rustModPathSep,rustSelf transparent

syn keyword   swayExternCrate crate contained nextgroup=rustIdentifier,rustExternCrateString skipwhite skipempty
" This is to get the `bar` part of `extern crate "foo" as bar;` highlighting.
syn match   swayExternCrateString /".*"\_s*as/ contained nextgroup=rustIdentifier skipwhite transparent skipempty contains=rustString,rustOperator
syn keyword   swayObsoleteExternMod mod contained nextgroup=rustIdentifier skipwhite skipempty

syn match     swayIdentifier  contains=rustIdentifierPrime "\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*" display contained
syn match     swayFuncName    "\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*" display contained

syn region    swayBoxPlacement matchgroup=rustBoxPlacementParens start="(" end=")" contains=TOP contained
" Ideally we'd have syntax rules set up to match arbitrary expressions. Since
" we don't, we'll just define temporary contained rules to handle balancing
" delimiters.
syn region    swayBoxPlacementBalance start="(" end=")" containedin=rustBoxPlacement transparent
syn region    swayBoxPlacementBalance start="\[" end="\]" containedin=rustBoxPlacement transparent
" {} are handled by swayFoldBraces

syn region swayMacroRepeat matchgroup=rustMacroRepeatDelimiters start="$(" end=")" contains=TOP nextgroup=rustMacroRepeatCount
syn match swayMacroRepeatCount ".\?[*+]" contained
syn match swayMacroVariable "$\w\+"

" Reserved (but not yet used) keywords {{{2
syn keyword   swayReservedKeyword alignof become do offsetof priv pure sizeof typeof unsized yield abstract virtual final override macro

" Built-in types {{{2
syn keyword   swayType        isize usize char bool u8 u16 u32 u64 u128 f32
syn keyword   swayType        f64 i8 i16 i32 i64 i128 str Self

" Things from the libstd v1 prelude (src/libstd/prelude/v1.rs) {{{2
" This section is just straight transformation of the contents of the prelude,
" to make it easy to update.

" Reexported core operators {{{3
syn keyword   swayTrait       Copy Send Sized Sync
syn keyword   swayTrait       Drop Fn FnMut FnOnce

" Reexported functions {{{3
" There’s no point in highlighting these; when one writes drop( or drop::< it
" gets the same highlighting anyway, and if someone writes `let drop = …;` we
" don’t really want *that* drop to be highlighted.
"syn keyword swayFunction drop

" Reexported types and traits {{{3
syn keyword swayTrait Box
syn keyword swayTrait ToOwned
syn keyword swayTrait Clone
syn keyword swayTrait PartialEq PartialOrd Eq Ord
syn keyword swayTrait AsRef AsMut Into From
syn keyword swayTrait Default
syn keyword swayTrait Iterator Extend IntoIterator
syn keyword swayTrait DoubleEndedIterator ExactSizeIterator
syn keyword swayEnum Option
syn keyword swayEnumVariant Some None
syn keyword swayEnum Result
syn keyword swayEnumVariant Ok Err
syn keyword swayTrait SliceConcatExt
syn keyword swayTrait String ToString
syn keyword swayTrait Vec

" Other syntax {{{2
syn keyword   swaySelf        self
syn keyword   swayBoolean     true false

" If foo::bar changes to foo.bar, change this ("::" to "\.").
" If foo::bar changes to Foo::bar, change this (first "\w" to "\u").
syn match     swayModPath     "\w\(\w\)*::[^<]"he=e-3,me=e-3
syn match     swayModPathSep  "::"

syn match     swayFuncCall    "\w\(\w\)*("he=e-1,me=e-1
syn match     swayFuncCall    "\w\(\w\)*::<"he=e-3,me=e-3 " foo::<T>();

" This is merely a convention; note also the use of [A-Z], restricting it to
" latin identifiers rather than the full Unicode uppercase. I have not used
" [:upper:] as it depends upon 'noignorecase'
"syn match     swayCapsIdent    display "[A-Z]\w\(\w\)*"

syn match     swayOperator     display "\%(+\|-\|/\|*\|=\|\^\|&\||\|!\|>\|<\|%\)=\?"
" This one isn't *quite* right, as we could have binary-& with a reference
syn match     swaySigil        display /&\s\+[&~@*][^)= \t\r\n]/he=e-1,me=e-1
syn match     swaySigil        display /[&~@*][^)= \t\r\n]/he=e-1,me=e-1
" This isn't actually correct; a closure with no arguments can be `|| { }`.
" Last, because the & in && isn't a sigil
syn match     swayOperator     display "&&\|||"
" This is swayArrowCharacter rather than rustArrow for the sake of matchparen,
" so it skips the ->; see http://stackoverflow.com/a/30309949 for details.
syn match     swayArrowCharacter display "->"
syn match     swayQuestionMark display "?\([a-zA-Z]\+\)\@!"

syn match     swayMacro       '\w\(\w\)*!' contains=rustAssert,rustPanic
syn match     swayMacro       '#\w\(\w\)*' contains=rustAssert,rustPanic

syn match     swayEscapeError   display contained /\\./
syn match     swayEscape        display contained /\\\([nrt0\\'"]\|x\x\{2}\)/
syn match     swayEscapeUnicode display contained /\\u{\x\{1,6}}/
syn match     swayStringContinuation display contained /\\\n\s*/
syn region    swayString      start=+b"+ skip=+\\\\\|\\"+ end=+"+ contains=rustEscape,rustEscapeError,rustStringContinuation
syn region    swayString      start=+"+ skip=+\\\\\|\\"+ end=+"+ contains=rustEscape,rustEscapeUnicode,rustEscapeError,rustStringContinuation,@Spell
syn region    swayString      start='b\?r\z(#*\)"' end='"\z1' contains=@Spell

syn region    swayAttribute   start="#!\?\[" end="\]" contains=rustString,rustDerive,rustCommentLine,rustCommentBlock,rustCommentLineDocError,rustCommentBlockDocError
syn region    swayDerive      start="derive(" end=")" contained contains=rustDeriveTrait
" This list comes from src/libsyntax/ext/deriving/mod.rs
" Some are deprecated (Encodable, Decodable) or to be removed after a new snapshot (Show).
syn keyword   swayDeriveTrait contained Clone Hash RustcEncodable RustcDecodable Encodable Decodable PartialEq Eq PartialOrd Ord Rand Show Debug Default FromPrimitive Send Sync Copy

" Number literals
syn match     swayDecNumber   display "\<[0-9][0-9_]*\%([iu]\%(size\|8\|16\|32\|64\|128\)\)\="
syn match     swayHexNumber   display "\<0x[a-fA-F0-9_]\+\%([iu]\%(size\|8\|16\|32\|64\|128\)\)\="
syn match     swayOctNumber   display "\<0o[0-7_]\+\%([iu]\%(size\|8\|16\|32\|64\|128\)\)\="
syn match     swayBinNumber   display "\<0b[01_]\+\%([iu]\%(size\|8\|16\|32\|64\|128\)\)\="

" Special case for numbers of the form "1." which are float literals, unless followed by
" an identifier, which makes them integer literals with a method call or field access,
" or by another ".", which makes them integer literals followed by the ".." token.
" (This must go first so the others take precedence.)
syn match     swayFloat       display "\<[0-9][0-9_]*\.\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\|\.\)\@!"
" To mark a number as a normal float, it must have at least one of the three things integral values don't have:
" a decimal point and more numbers; an exponent; and a type suffix.
syn match     swayFloat       display "\<[0-9][0-9_]*\%(\.[0-9][0-9_]*\)\%([eE][+-]\=[0-9_]\+\)\=\(f32\|f64\)\="
syn match     swayFloat       display "\<[0-9][0-9_]*\%(\.[0-9][0-9_]*\)\=\%([eE][+-]\=[0-9_]\+\)\(f32\|f64\)\="
syn match     swayFloat       display "\<[0-9][0-9_]*\%(\.[0-9][0-9_]*\)\=\%([eE][+-]\=[0-9_]\+\)\=\(f32\|f64\)"

" For the benefit of delimitMate
syn region swayLifetimeCandidate display start=/&'\%(\([^'\\]\|\\\(['nrt0\\\"]\|x\x\{2}\|u{\x\{1,6}}\)\)'\)\@!/ end=/[[:cntrl:][:space:][:punct:]]\@=\|$/ contains=rustSigil,rustLifetime
syn region swayGenericRegion display start=/<\%('\|[^[cntrl:][:space:][:punct:]]\)\@=')\S\@=/ end=/>/ contains=rustGenericLifetimeCandidate
syn region swayGenericLifetimeCandidate display start=/\%(<\|,\s*\)\@<='/ end=/[[:cntrl:][:space:][:punct:]]\@=\|$/ contains=rustSigil,rustLifetime

"swayLifetime must appear before rustCharacter, or chars will get the lifetime highlighting
syn match     swayLifetime    display "\'\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*"
syn match     swayLabel       display "\'\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*:"
syn match   swayCharacterInvalid   display contained /b\?'\zs[\n\r\t']\ze'/
" The groups negated here add up to 0-255 but nothing else (they do not seem to go beyond ASCII).
syn match   swayCharacterInvalidUnicode   display contained /b'\zs[^[:cntrl:][:graph:][:alnum:][:space:]]\ze'/
syn match   swayCharacter   /b'\([^\\]\|\\\(.\|x\x\{2}\)\)'/ contains=rustEscape,rustEscapeError,rustCharacterInvalid,rustCharacterInvalidUnicode
syn match   swayCharacter   /'\([^\\]\|\\\(.\|x\x\{2}\|u{\x\{1,6}}\)\)'/ contains=rustEscape,rustEscapeUnicode,rustEscapeError,rustCharacterInvalid

syn match swayShebang /\%^#![^[].*/
syn region swayCommentLine                                                  start="//"                      end="$"   contains=rustTodo,@Spell
syn region swayCommentLineDoc                                               start="//\%(//\@!\|!\)"         end="$"   contains=rustTodo,@Spell
syn region swayCommentLineDocError                                          start="//\%(//\@!\|!\)"         end="$"   contains=rustTodo,@Spell contained
syn region swayCommentBlock             matchgroup=rustCommentBlock         start="/\*\%(!\|\*[*/]\@!\)\@!" end="\*/" contains=rustTodo,rustCommentBlockNest,@Spell
syn region swayCommentBlockDoc          matchgroup=rustCommentBlockDoc      start="/\*\%(!\|\*[*/]\@!\)"    end="\*/" contains=rustTodo,rustCommentBlockDocNest,@Spell
syn region swayCommentBlockDocError     matchgroup=rustCommentBlockDocError start="/\*\%(!\|\*[*/]\@!\)"    end="\*/" contains=rustTodo,rustCommentBlockDocNestError,@Spell contained
syn region swayCommentBlockNest         matchgroup=rustCommentBlock         start="/\*"                     end="\*/" contains=rustTodo,rustCommentBlockNest,@Spell contained transparent
syn region swayCommentBlockDocNest      matchgroup=rustCommentBlockDoc      start="/\*"                     end="\*/" contains=rustTodo,rustCommentBlockDocNest,@Spell contained transparent
syn region swayCommentBlockDocNestError matchgroup=rustCommentBlockDocError start="/\*"                     end="\*/" contains=rustTodo,rustCommentBlockDocNestError,@Spell contained transparent
" FIXME: this is a really ugly and not fully correct implementation. Most
" importantly, a case like ``/* */*`` should have the final ``*`` not being in
" a comment, but in practice at present it leaves comments open two levels
" deep. But as long as you stay away from that particular case, I *believe*
" the highlighting is correct. Due to the way Vim's syntax engine works
" (greedy for start matches, unlike Rust's tokeniser which is searching for
" the earliest-starting match, start or end), I believe this cannot be solved.
" Oh you who would fix it, don't bother with things like duplicating the Block
" rules and putting ``\*\@<!`` at the start of them; it makes it worse, as
" then you must deal with cases like ``/*/**/*/``. And don't try making it
" worse with ``\%(/\@<!\*\)\@<!``, either...

syn keyword swayTodo contained TODO FIXME XXX NB NOTE

" Folding rules {{{2
" Trivial folding rules to begin with.
" FIXME: use the AST to make really good folding
syn region swayFoldBraces start="{" end="}" transparent fold

" Default highlighting {{{1
hi def link swayDecNumber       rustNumber
hi def link swayHexNumber       rustNumber
hi def link swayOctNumber       rustNumber
hi def link swayBinNumber       rustNumber
hi def link swayIdentifierPrime rustIdentifier
hi def link swayTrait           rustType
hi def link swayDeriveTrait     rustTrait

hi def link swayMacroRepeatCount   rustMacroRepeatDelimiters
hi def link swayMacroRepeatDelimiters   Macro
hi def link swayMacroVariable Define
hi def link swaySigil         StorageClass
hi def link swayEscape        Special
hi def link swayEscapeUnicode rustEscape
hi def link swayEscapeError   Error
hi def link swayStringContinuation Special
hi def link swayString        String
hi def link swayCharacterInvalid Error
hi def link swayCharacterInvalidUnicode rustCharacterInvalid
hi def link swayCharacter     Character
hi def link swayNumber        Number
hi def link swayBoolean       Boolean
hi def link swayEnum          rustType
hi def link swayEnumVariant   rustConstant
hi def link swayConstant      Constant
hi def link swaySelf          Constant
hi def link swayFloat         Float
hi def link swayArrowCharacter rustOperator
hi def link swayOperator      Operator
hi def link swayKeyword       Keyword
hi def link swayTypedef       Keyword " More precise is Typedef, but it doesn't feel right for Rust
hi def link swayStructure     Keyword " More precise is Structure
hi def link swayUnion         rustStructure
hi def link swayPubScopeDelim Delimiter
hi def link swayPubScopeCrate rustKeyword
hi def link swaySuper         rustKeyword
hi def link swayReservedKeyword Error
hi def link swayRepeat        Conditional
hi def link swayConditional   Conditional
hi def link swayIdentifier    Identifier
hi def link swayCapsIdent     rustIdentifier
hi def link swayModPath       Include
hi def link swayModPathSep    Delimiter
hi def link swayFunction      Function
hi def link swayFuncName      Function
hi def link swayFuncCall      Function
hi def link swayShebang       Comment
hi def link swayCommentLine   Comment
hi def link swayCommentLineDoc SpecialComment
hi def link swayCommentLineDocError Error
hi def link swayCommentBlock  rustCommentLine
hi def link swayCommentBlockDoc rustCommentLineDoc
hi def link swayCommentBlockDocError Error
hi def link swayAssert        PreCondit
hi def link swayPanic         PreCondit
hi def link swayMacro         Macro
hi def link swayType          Type
hi def link swayTodo          Todo
hi def link swayAttribute     PreProc
hi def link swayDerive        PreProc
hi def link swayDefault       StorageClass
hi def link swayStorage       StorageClass
hi def link swayObsoleteStorage Error
hi def link swayLifetime      Special
hi def link swayLabel         Label
hi def link swayInvalidBareKeyword Error
hi def link swayExternCrate   rustKeyword
hi def link swayObsoleteExternMod Error
hi def link swayBoxPlacementParens Delimiter
hi def link swayQuestionMark  Special

" Other Suggestions:
" hi swayAttribute ctermfg=cyan
" hi swayDerive ctermfg=cyan
" hi swayAssert ctermfg=yellow
" hi swayPanic ctermfg=red
" hi swayMacro ctermfg=magenta

syn sync minlines=200
syn sync maxlines=500

let b:current_syntax = "sway"
