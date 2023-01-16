local LSP = {}

---@enum insx.kit.LSP.SemanticTokenTypes
LSP.SemanticTokenTypes = {
  namespace = 'namespace',
  type = 'type',
  class = 'class',
  enum = 'enum',
  interface = 'interface',
  struct = 'struct',
  typeParameter = 'typeParameter',
  parameter = 'parameter',
  variable = 'variable',
  property = 'property',
  enumMember = 'enumMember',
  event = 'event',
  ['function'] = 'function',
  method = 'method',
  macro = 'macro',
  keyword = 'keyword',
  modifier = 'modifier',
  comment = 'comment',
  string = 'string',
  number = 'number',
  regexp = 'regexp',
  operator = 'operator',
  decorator = 'decorator',
}

---@enum insx.kit.LSP.SemanticTokenModifiers
LSP.SemanticTokenModifiers = {
  declaration = 'declaration',
  definition = 'definition',
  readonly = 'readonly',
  static = 'static',
  deprecated = 'deprecated',
  abstract = 'abstract',
  async = 'async',
  modification = 'modification',
  documentation = 'documentation',
  defaultLibrary = 'defaultLibrary',
}

---@enum insx.kit.LSP.DocumentDiagnosticReportKind
LSP.DocumentDiagnosticReportKind = {
  Full = 'full',
  Unchanged = 'unchanged',
}

---@enum insx.kit.LSP.ErrorCodes
LSP.ErrorCodes = {
  ParseError = -32700,
  InvalidRequest = -32600,
  MethodNotFound = -32601,
  InvalidParams = -32602,
  InternalError = -32603,
  ServerNotInitialized = -32002,
  UnknownErrorCode = -32001,
}

---@enum insx.kit.LSP.LSPErrorCodes
LSP.LSPErrorCodes = {
  RequestFailed = -32803,
  ServerCancelled = -32802,
  ContentModified = -32801,
  RequestCancelled = -32800,
}

---@enum insx.kit.LSP.FoldingRangeKind
LSP.FoldingRangeKind = {
  Comment = 'comment',
  Imports = 'imports',
  Region = 'region',
}

---@enum insx.kit.LSP.SymbolKind
LSP.SymbolKind = {
  File = 1,
  Module = 2,
  Namespace = 3,
  Package = 4,
  Class = 5,
  Method = 6,
  Property = 7,
  Field = 8,
  Constructor = 9,
  Enum = 10,
  Interface = 11,
  Function = 12,
  Variable = 13,
  Constant = 14,
  String = 15,
  Number = 16,
  Boolean = 17,
  Array = 18,
  Object = 19,
  Key = 20,
  Null = 21,
  EnumMember = 22,
  Struct = 23,
  Event = 24,
  Operator = 25,
  TypeParameter = 26,
}

---@enum insx.kit.LSP.SymbolTag
LSP.SymbolTag = {
  Deprecated = 1,
}

---@enum insx.kit.LSP.UniquenessLevel
LSP.UniquenessLevel = {
  document = 'document',
  project = 'project',
  group = 'group',
  scheme = 'scheme',
  global = 'global',
}

---@enum insx.kit.LSP.MonikerKind
LSP.MonikerKind = {
  import = 'import',
  export = 'export',
  ['local'] = 'local',
}

---@enum insx.kit.LSP.InlayHintKind
LSP.InlayHintKind = {
  Type = 1,
  Parameter = 2,
}

---@enum insx.kit.LSP.MessageType
LSP.MessageType = {
  Error = 1,
  Warning = 2,
  Info = 3,
  Log = 4,
}

---@enum insx.kit.LSP.TextDocumentSyncKind
LSP.TextDocumentSyncKind = {
  None = 0,
  Full = 1,
  Incremental = 2,
}

---@enum insx.kit.LSP.TextDocumentSaveReason
LSP.TextDocumentSaveReason = {
  Manual = 1,
  AfterDelay = 2,
  FocusOut = 3,
}

---@enum insx.kit.LSP.CompletionItemKind
LSP.CompletionItemKind = {
  Text = 1,
  Method = 2,
  Function = 3,
  Constructor = 4,
  Field = 5,
  Variable = 6,
  Class = 7,
  Interface = 8,
  Module = 9,
  Property = 10,
  Unit = 11,
  Value = 12,
  Enum = 13,
  Keyword = 14,
  Snippet = 15,
  Color = 16,
  File = 17,
  Reference = 18,
  Folder = 19,
  EnumMember = 20,
  Constant = 21,
  Struct = 22,
  Event = 23,
  Operator = 24,
  TypeParameter = 25,
}

---@enum insx.kit.LSP.CompletionItemTag
LSP.CompletionItemTag = {
  Deprecated = 1,
}

---@enum insx.kit.LSP.InsertTextFormat
LSP.InsertTextFormat = {
  PlainText = 1,
  Snippet = 2,
}

---@enum insx.kit.LSP.InsertTextMode
LSP.InsertTextMode = {
  asIs = 1,
  adjustIndentation = 2,
}

---@enum insx.kit.LSP.DocumentHighlightKind
LSP.DocumentHighlightKind = {
  Text = 1,
  Read = 2,
  Write = 3,
}

---@enum insx.kit.LSP.CodeActionKind
LSP.CodeActionKind = {
  Empty = '',
  QuickFix = 'quickfix',
  Refactor = 'refactor',
  RefactorExtract = 'refactor.extract',
  RefactorInline = 'refactor.inline',
  RefactorRewrite = 'refactor.rewrite',
  Source = 'source',
  SourceOrganizeImports = 'source.organizeImports',
  SourceFixAll = 'source.fixAll',
}

---@enum insx.kit.LSP.TraceValues
LSP.TraceValues = {
  Off = 'off',
  Messages = 'messages',
  Verbose = 'verbose',
}

---@enum insx.kit.LSP.MarkupKind
LSP.MarkupKind = {
  PlainText = 'plaintext',
  Markdown = 'markdown',
}

---@enum insx.kit.LSP.PositionEncodingKind
LSP.PositionEncodingKind = {
  UTF8 = 'utf-8',
  UTF16 = 'utf-16',
  UTF32 = 'utf-32',
}

---@enum insx.kit.LSP.FileChangeType
LSP.FileChangeType = {
  Created = 1,
  Changed = 2,
  Deleted = 3,
}

---@enum insx.kit.LSP.WatchKind
LSP.WatchKind = {
  Create = 1,
  Change = 2,
  Delete = 4,
}

---@enum insx.kit.LSP.DiagnosticSeverity
LSP.DiagnosticSeverity = {
  Error = 1,
  Warning = 2,
  Information = 3,
  Hint = 4,
}

---@enum insx.kit.LSP.DiagnosticTag
LSP.DiagnosticTag = {
  Unnecessary = 1,
  Deprecated = 2,
}

---@enum insx.kit.LSP.CompletionTriggerKind
LSP.CompletionTriggerKind = {
  Invoked = 1,
  TriggerCharacter = 2,
  TriggerForIncompleteCompletions = 3,
}

---@enum insx.kit.LSP.SignatureHelpTriggerKind
LSP.SignatureHelpTriggerKind = {
  Invoked = 1,
  TriggerCharacter = 2,
  ContentChange = 3,
}

---@enum insx.kit.LSP.CodeActionTriggerKind
LSP.CodeActionTriggerKind = {
  Invoked = 1,
  Automatic = 2,
}

---@enum insx.kit.LSP.FileOperationPatternKind
LSP.FileOperationPatternKind = {
  file = 'file',
  folder = 'folder',
}

---@enum insx.kit.LSP.NotebookCellKind
LSP.NotebookCellKind = {
  Markup = 1,
  Code = 2,
}

---@enum insx.kit.LSP.ResourceOperationKind
LSP.ResourceOperationKind = {
  Create = 'create',
  Rename = 'rename',
  Delete = 'delete',
}

---@enum insx.kit.LSP.FailureHandlingKind
LSP.FailureHandlingKind = {
  Abort = 'abort',
  Transactional = 'transactional',
  TextOnlyTransactional = 'textOnlyTransactional',
  Undo = 'undo',
}

---@enum insx.kit.LSP.PrepareSupportDefaultBehavior
LSP.PrepareSupportDefaultBehavior = {
  Identifier = 1,
}

---@enum insx.kit.LSP.TokenFormat
LSP.TokenFormat = {
  Relative = 'relative',
}

---@class insx.kit.LSP.ImplementationParams : insx.kit.LSP.TextDocumentPositionParams, insx.kit.LSP.WorkDoneProgressParams, insx.kit.LSP.PartialResultParams

---@class insx.kit.LSP.Location
---@field public uri string
---@field public range insx.kit.LSP.Range

---@class insx.kit.LSP.ImplementationRegistrationOptions : insx.kit.LSP.TextDocumentRegistrationOptions, insx.kit.LSP.ImplementationOptions, insx.kit.LSP.StaticRegistrationOptions

---@class insx.kit.LSP.TypeDefinitionParams : insx.kit.LSP.TextDocumentPositionParams, insx.kit.LSP.WorkDoneProgressParams, insx.kit.LSP.PartialResultParams

---@class insx.kit.LSP.TypeDefinitionRegistrationOptions : insx.kit.LSP.TextDocumentRegistrationOptions, insx.kit.LSP.TypeDefinitionOptions, insx.kit.LSP.StaticRegistrationOptions

---@class insx.kit.LSP.WorkspaceFolder
---@field public uri string The associated URI for this workspace folder.
---@field public name string The name of the workspace folder. Used to refer to this<br>workspace folder in the user interface.

---@class insx.kit.LSP.DidChangeWorkspaceFoldersParams
---@field public event insx.kit.LSP.WorkspaceFoldersChangeEvent The actual workspace folder change event.

---@class insx.kit.LSP.ConfigurationParams
---@field public items insx.kit.LSP.ConfigurationItem[]

---@class insx.kit.LSP.PartialResultParams
---@field public partialResultToken? insx.kit.LSP.ProgressToken An optional token that a server can use to report partial results (e.g. streaming) to<br>the client.

---@class insx.kit.LSP.DocumentColorParams : insx.kit.LSP.WorkDoneProgressParams, insx.kit.LSP.PartialResultParams
---@field public textDocument insx.kit.LSP.TextDocumentIdentifier The text document.

---@class insx.kit.LSP.ColorInformation
---@field public range insx.kit.LSP.Range The range in the document where this color appears.
---@field public color insx.kit.LSP.Color The actual color value for this color range.

---@class insx.kit.LSP.DocumentColorRegistrationOptions : insx.kit.LSP.TextDocumentRegistrationOptions, insx.kit.LSP.DocumentColorOptions, insx.kit.LSP.StaticRegistrationOptions

---@class insx.kit.LSP.ColorPresentationParams : insx.kit.LSP.WorkDoneProgressParams, insx.kit.LSP.PartialResultParams
---@field public textDocument insx.kit.LSP.TextDocumentIdentifier The text document.
---@field public color insx.kit.LSP.Color The color to request presentations for.
---@field public range insx.kit.LSP.Range The range where the color would be inserted. Serves as a context.

---@class insx.kit.LSP.ColorPresentation
---@field public label string The label of this color presentation. It will be shown on the color<br>picker header. By default this is also the text that is inserted when selecting<br>this color presentation.
---@field public textEdit? insx.kit.LSP.TextEdit An [edit](#TextEdit) which is applied to a document when selecting<br>this presentation for the color.  When `falsy` the [label](#ColorPresentation.label)<br>is used.
---@field public additionalTextEdits? insx.kit.LSP.TextEdit[] An optional array of additional [text edits](#TextEdit) that are applied when<br>selecting this color presentation. Edits must not overlap with the main [edit](#ColorPresentation.textEdit) nor with themselves.

---@class insx.kit.LSP.WorkDoneProgressOptions
---@field public workDoneProgress? boolean

---@class insx.kit.LSP.TextDocumentRegistrationOptions
---@field public documentSelector (insx.kit.LSP.DocumentSelector | nil) A document selector to identify the scope of the registration. If set to null<br>the document selector provided on the client side will be used.

---@class insx.kit.LSP.FoldingRangeParams : insx.kit.LSP.WorkDoneProgressParams, insx.kit.LSP.PartialResultParams
---@field public textDocument insx.kit.LSP.TextDocumentIdentifier The text document.

---@class insx.kit.LSP.FoldingRange
---@field public startLine integer The zero-based start line of the range to fold. The folded area starts after the line's last character.<br>To be valid, the end must be zero or larger and smaller than the number of lines in the document.
---@field public startCharacter? integer The zero-based character offset from where the folded range starts. If not defined, defaults to the length of the start line.
---@field public endLine integer The zero-based end line of the range to fold. The folded area ends with the line's last character.<br>To be valid, the end must be zero or larger and smaller than the number of lines in the document.
---@field public endCharacter? integer The zero-based character offset before the folded range ends. If not defined, defaults to the length of the end line.
---@field public kind? insx.kit.LSP.FoldingRangeKind Describes the kind of the folding range such as `comment' or 'region'. The kind<br>is used to categorize folding ranges and used by commands like 'Fold all comments'.<br>See [FoldingRangeKind](#FoldingRangeKind) for an enumeration of standardized kinds.
---@field public collapsedText? string The text that the client should show when the specified range is<br>collapsed. If not defined or not supported by the client, a default<br>will be chosen by the client.<br><br>@since 3.17.0

---@class insx.kit.LSP.FoldingRangeRegistrationOptions : insx.kit.LSP.TextDocumentRegistrationOptions, insx.kit.LSP.FoldingRangeOptions, insx.kit.LSP.StaticRegistrationOptions

---@class insx.kit.LSP.DeclarationParams : insx.kit.LSP.TextDocumentPositionParams, insx.kit.LSP.WorkDoneProgressParams, insx.kit.LSP.PartialResultParams

---@class insx.kit.LSP.DeclarationRegistrationOptions : insx.kit.LSP.DeclarationOptions, insx.kit.LSP.TextDocumentRegistrationOptions, insx.kit.LSP.StaticRegistrationOptions

---@class insx.kit.LSP.SelectionRangeParams : insx.kit.LSP.WorkDoneProgressParams, insx.kit.LSP.PartialResultParams
---@field public textDocument insx.kit.LSP.TextDocumentIdentifier The text document.
---@field public positions insx.kit.LSP.Position[] The positions inside the text document.

---@class insx.kit.LSP.SelectionRange
---@field public range insx.kit.LSP.Range The [range](#Range) of this selection range.
---@field public parent? insx.kit.LSP.SelectionRange The parent selection range containing this range. Therefore `parent.range` must contain `this.range`.

---@class insx.kit.LSP.SelectionRangeRegistrationOptions : insx.kit.LSP.SelectionRangeOptions, insx.kit.LSP.TextDocumentRegistrationOptions, insx.kit.LSP.StaticRegistrationOptions

---@class insx.kit.LSP.WorkDoneProgressCreateParams
---@field public token insx.kit.LSP.ProgressToken The token to be used to report progress.

---@class insx.kit.LSP.WorkDoneProgressCancelParams
---@field public token insx.kit.LSP.ProgressToken The token to be used to report progress.

---@class insx.kit.LSP.CallHierarchyPrepareParams : insx.kit.LSP.TextDocumentPositionParams, insx.kit.LSP.WorkDoneProgressParams

---@class insx.kit.LSP.CallHierarchyItem
---@field public name string The name of this item.
---@field public kind insx.kit.LSP.SymbolKind The kind of this item.
---@field public tags? insx.kit.LSP.SymbolTag[] Tags for this item.
---@field public detail? string More detail for this item, e.g. the signature of a function.
---@field public uri string The resource identifier of this item.
---@field public range insx.kit.LSP.Range The range enclosing this symbol not including leading/trailing whitespace but everything else, e.g. comments and code.
---@field public selectionRange insx.kit.LSP.Range The range that should be selected and revealed when this symbol is being picked, e.g. the name of a function.<br>Must be contained by the [`range`](#CallHierarchyItem.range).
---@field public data? insx.kit.LSP.LSPAny A data entry field that is preserved between a call hierarchy prepare and<br>incoming calls or outgoing calls requests.

---@class insx.kit.LSP.CallHierarchyRegistrationOptions : insx.kit.LSP.TextDocumentRegistrationOptions, insx.kit.LSP.CallHierarchyOptions, insx.kit.LSP.StaticRegistrationOptions

---@class insx.kit.LSP.CallHierarchyIncomingCallsParams : insx.kit.LSP.WorkDoneProgressParams, insx.kit.LSP.PartialResultParams
---@field public item insx.kit.LSP.CallHierarchyItem

---@class insx.kit.LSP.CallHierarchyIncomingCall
---@field public from insx.kit.LSP.CallHierarchyItem The item that makes the call.
---@field public fromRanges insx.kit.LSP.Range[] The ranges at which the calls appear. This is relative to the caller<br>denoted by [`this.from`](#CallHierarchyIncomingCall.from).

---@class insx.kit.LSP.CallHierarchyOutgoingCallsParams : insx.kit.LSP.WorkDoneProgressParams, insx.kit.LSP.PartialResultParams
---@field public item insx.kit.LSP.CallHierarchyItem

---@class insx.kit.LSP.CallHierarchyOutgoingCall
---@field public to insx.kit.LSP.CallHierarchyItem The item that is called.
---@field public fromRanges insx.kit.LSP.Range[] The range at which this item is called. This is the range relative to the caller, e.g the item<br>passed to [`provideCallHierarchyOutgoingCalls`](#CallHierarchyItemProvider.provideCallHierarchyOutgoingCalls)<br>and not [`this.to`](#CallHierarchyOutgoingCall.to).

---@class insx.kit.LSP.SemanticTokensParams : insx.kit.LSP.WorkDoneProgressParams, insx.kit.LSP.PartialResultParams
---@field public textDocument insx.kit.LSP.TextDocumentIdentifier The text document.

---@class insx.kit.LSP.SemanticTokens
---@field public resultId? string An optional result id. If provided and clients support delta updating<br>the client will include the result id in the next semantic token request.<br>A server can then instead of computing all semantic tokens again simply<br>send a delta.
---@field public data integer[] The actual tokens.

---@class insx.kit.LSP.SemanticTokensPartialResult
---@field public data integer[]

---@class insx.kit.LSP.SemanticTokensRegistrationOptions : insx.kit.LSP.TextDocumentRegistrationOptions, insx.kit.LSP.SemanticTokensOptions, insx.kit.LSP.StaticRegistrationOptions

---@class insx.kit.LSP.SemanticTokensDeltaParams : insx.kit.LSP.WorkDoneProgressParams, insx.kit.LSP.PartialResultParams
---@field public textDocument insx.kit.LSP.TextDocumentIdentifier The text document.
---@field public previousResultId string The result id of a previous response. The result Id can either point to a full response<br>or a delta response depending on what was received last.

---@class insx.kit.LSP.SemanticTokensDelta
---@field public resultId? string
---@field public edits insx.kit.LSP.SemanticTokensEdit[] The semantic token edits to transform a previous result into a new result.

---@class insx.kit.LSP.SemanticTokensDeltaPartialResult
---@field public edits insx.kit.LSP.SemanticTokensEdit[]

---@class insx.kit.LSP.SemanticTokensRangeParams : insx.kit.LSP.WorkDoneProgressParams, insx.kit.LSP.PartialResultParams
---@field public textDocument insx.kit.LSP.TextDocumentIdentifier The text document.
---@field public range insx.kit.LSP.Range The range the semantic tokens are requested for.

---@class insx.kit.LSP.ShowDocumentParams
---@field public uri string The document uri to show.
---@field public external? boolean Indicates to show the resource in an external program.<br>To show for example `https://code.visualstudio.com/`<br>in the default WEB browser set `external` to `true`.
---@field public takeFocus? boolean An optional property to indicate whether the editor<br>showing the document should take focus or not.<br>Clients might ignore this property if an external<br>program is started.
---@field public selection? insx.kit.LSP.Range An optional selection range if the document is a text<br>document. Clients might ignore the property if an<br>external program is started or the file is not a text<br>file.

---@class insx.kit.LSP.ShowDocumentResult
---@field public success boolean A boolean indicating if the show was successful.

---@class insx.kit.LSP.LinkedEditingRangeParams : insx.kit.LSP.TextDocumentPositionParams, insx.kit.LSP.WorkDoneProgressParams

---@class insx.kit.LSP.LinkedEditingRanges
---@field public ranges insx.kit.LSP.Range[] A list of ranges that can be edited together. The ranges must have<br>identical length and contain identical text content. The ranges cannot overlap.
---@field public wordPattern? string An optional word pattern (regular expression) that describes valid contents for<br>the given ranges. If no pattern is provided, the client configuration's word<br>pattern will be used.

---@class insx.kit.LSP.LinkedEditingRangeRegistrationOptions : insx.kit.LSP.TextDocumentRegistrationOptions, insx.kit.LSP.LinkedEditingRangeOptions, insx.kit.LSP.StaticRegistrationOptions

---@class insx.kit.LSP.CreateFilesParams
---@field public files insx.kit.LSP.FileCreate[] An array of all files/folders created in this operation.

---@class insx.kit.LSP.WorkspaceEdit
---@field public changes? table<string, insx.kit.LSP.TextEdit[]> Holds changes to existing resources.
---@field public documentChanges? (insx.kit.LSP.TextDocumentEdit | insx.kit.LSP.CreateFile | insx.kit.LSP.RenameFile | insx.kit.LSP.DeleteFile)[] Depending on the client capability `workspace.workspaceEdit.resourceOperations` document changes<br>are either an array of `TextDocumentEdit`s to express changes to n different text documents<br>where each text document edit addresses a specific version of a text document. Or it can contain<br>above `TextDocumentEdit`s mixed with create, rename and delete file / folder operations.<br><br>Whether a client supports versioned document edits is expressed via<br>`workspace.workspaceEdit.documentChanges` client capability.<br><br>If a client neither supports `documentChanges` nor `workspace.workspaceEdit.resourceOperations` then<br>only plain `TextEdit`s using the `changes` property are supported.
---@field public changeAnnotations? table<insx.kit.LSP.ChangeAnnotationIdentifier, insx.kit.LSP.ChangeAnnotation> A map of change annotations that can be referenced in `AnnotatedTextEdit`s or create, rename and<br>delete file / folder operations.<br><br>Whether clients honor this property depends on the client capability `workspace.changeAnnotationSupport`.<br><br>@since 3.16.0

---@class insx.kit.LSP.FileOperationRegistrationOptions
---@field public filters insx.kit.LSP.FileOperationFilter[] The actual filters.

---@class insx.kit.LSP.RenameFilesParams
---@field public files insx.kit.LSP.FileRename[] An array of all files/folders renamed in this operation. When a folder is renamed, only<br>the folder will be included, and not its children.

---@class insx.kit.LSP.DeleteFilesParams
---@field public files insx.kit.LSP.FileDelete[] An array of all files/folders deleted in this operation.

---@class insx.kit.LSP.MonikerParams : insx.kit.LSP.TextDocumentPositionParams, insx.kit.LSP.WorkDoneProgressParams, insx.kit.LSP.PartialResultParams

---@class insx.kit.LSP.Moniker
---@field public scheme string The scheme of the moniker. For example tsc or .Net
---@field public identifier string The identifier of the moniker. The value is opaque in LSIF however<br>schema owners are allowed to define the structure if they want.
---@field public unique insx.kit.LSP.UniquenessLevel The scope in which the moniker is unique
---@field public kind? insx.kit.LSP.MonikerKind The moniker kind if known.

---@class insx.kit.LSP.MonikerRegistrationOptions : insx.kit.LSP.TextDocumentRegistrationOptions, insx.kit.LSP.MonikerOptions

---@class insx.kit.LSP.TypeHierarchyPrepareParams : insx.kit.LSP.TextDocumentPositionParams, insx.kit.LSP.WorkDoneProgressParams

---@class insx.kit.LSP.TypeHierarchyItem
---@field public name string The name of this item.
---@field public kind insx.kit.LSP.SymbolKind The kind of this item.
---@field public tags? insx.kit.LSP.SymbolTag[] Tags for this item.
---@field public detail? string More detail for this item, e.g. the signature of a function.
---@field public uri string The resource identifier of this item.
---@field public range insx.kit.LSP.Range The range enclosing this symbol not including leading/trailing whitespace<br>but everything else, e.g. comments and code.
---@field public selectionRange insx.kit.LSP.Range The range that should be selected and revealed when this symbol is being<br>picked, e.g. the name of a function. Must be contained by the<br>[`range`](#TypeHierarchyItem.range).
---@field public data? insx.kit.LSP.LSPAny A data entry field that is preserved between a type hierarchy prepare and<br>supertypes or subtypes requests. It could also be used to identify the<br>type hierarchy in the server, helping improve the performance on<br>resolving supertypes and subtypes.

---@class insx.kit.LSP.TypeHierarchyRegistrationOptions : insx.kit.LSP.TextDocumentRegistrationOptions, insx.kit.LSP.TypeHierarchyOptions, insx.kit.LSP.StaticRegistrationOptions

---@class insx.kit.LSP.TypeHierarchySupertypesParams : insx.kit.LSP.WorkDoneProgressParams, insx.kit.LSP.PartialResultParams
---@field public item insx.kit.LSP.TypeHierarchyItem

---@class insx.kit.LSP.TypeHierarchySubtypesParams : insx.kit.LSP.WorkDoneProgressParams, insx.kit.LSP.PartialResultParams
---@field public item insx.kit.LSP.TypeHierarchyItem

---@class insx.kit.LSP.InlineValueParams : insx.kit.LSP.WorkDoneProgressParams
---@field public textDocument insx.kit.LSP.TextDocumentIdentifier The text document.
---@field public range insx.kit.LSP.Range The document range for which inline values should be computed.
---@field public context insx.kit.LSP.InlineValueContext Additional information about the context in which inline values were<br>requested.

---@class insx.kit.LSP.InlineValueRegistrationOptions : insx.kit.LSP.InlineValueOptions, insx.kit.LSP.TextDocumentRegistrationOptions, insx.kit.LSP.StaticRegistrationOptions

---@class insx.kit.LSP.InlayHintParams : insx.kit.LSP.WorkDoneProgressParams
---@field public textDocument insx.kit.LSP.TextDocumentIdentifier The text document.
---@field public range insx.kit.LSP.Range The document range for which inlay hints should be computed.

---@class insx.kit.LSP.InlayHint
---@field public position insx.kit.LSP.Position The position of this hint.
---@field public label (string | insx.kit.LSP.InlayHintLabelPart[]) The label of this hint. A human readable string or an array of<br>InlayHintLabelPart label parts.<br><br>*Note* that neither the string nor the label part can be empty.
---@field public kind? insx.kit.LSP.InlayHintKind The kind of this hint. Can be omitted in which case the client<br>should fall back to a reasonable default.
---@field public textEdits? insx.kit.LSP.TextEdit[] Optional text edits that are performed when accepting this inlay hint.<br><br>*Note* that edits are expected to change the document so that the inlay<br>hint (or its nearest variant) is now part of the document and the inlay<br>hint itself is now obsolete.
---@field public tooltip? (string | insx.kit.LSP.MarkupContent) The tooltip text when you hover over this item.
---@field public paddingLeft? boolean Render padding before the hint.<br><br>Note: Padding should use the editor's background color, not the<br>background color of the hint itself. That means padding can be used<br>to visually align/separate an inlay hint.
---@field public paddingRight? boolean Render padding after the hint.<br><br>Note: Padding should use the editor's background color, not the<br>background color of the hint itself. That means padding can be used<br>to visually align/separate an inlay hint.
---@field public data? insx.kit.LSP.LSPAny A data entry field that is preserved on an inlay hint between<br>a `textDocument/inlayHint` and a `inlayHint/resolve` request.

---@class insx.kit.LSP.InlayHintRegistrationOptions : insx.kit.LSP.InlayHintOptions, insx.kit.LSP.TextDocumentRegistrationOptions, insx.kit.LSP.StaticRegistrationOptions

---@class insx.kit.LSP.DocumentDiagnosticParams : insx.kit.LSP.WorkDoneProgressParams, insx.kit.LSP.PartialResultParams
---@field public textDocument insx.kit.LSP.TextDocumentIdentifier The text document.
---@field public identifier? string The additional identifier  provided during registration.
---@field public previousResultId? string The result id of a previous response if provided.

---@class insx.kit.LSP.DocumentDiagnosticReportPartialResult
---@field public relatedDocuments table<string, (insx.kit.LSP.FullDocumentDiagnosticReport | insx.kit.LSP.UnchangedDocumentDiagnosticReport)>

---@class insx.kit.LSP.DiagnosticServerCancellationData
---@field public retriggerRequest boolean

---@class insx.kit.LSP.DiagnosticRegistrationOptions : insx.kit.LSP.TextDocumentRegistrationOptions, insx.kit.LSP.DiagnosticOptions, insx.kit.LSP.StaticRegistrationOptions

---@class insx.kit.LSP.WorkspaceDiagnosticParams : insx.kit.LSP.WorkDoneProgressParams, insx.kit.LSP.PartialResultParams
---@field public identifier? string The additional identifier provided during registration.
---@field public previousResultIds insx.kit.LSP.PreviousResultId[] The currently known diagnostic reports with their<br>previous result ids.

---@class insx.kit.LSP.WorkspaceDiagnosticReport
---@field public items insx.kit.LSP.WorkspaceDocumentDiagnosticReport[]

---@class insx.kit.LSP.WorkspaceDiagnosticReportPartialResult
---@field public items insx.kit.LSP.WorkspaceDocumentDiagnosticReport[]

---@class insx.kit.LSP.DidOpenNotebookDocumentParams
---@field public notebookDocument insx.kit.LSP.NotebookDocument The notebook document that got opened.
---@field public cellTextDocuments insx.kit.LSP.TextDocumentItem[] The text documents that represent the content<br>of a notebook cell.

---@class insx.kit.LSP.DidChangeNotebookDocumentParams
---@field public notebookDocument insx.kit.LSP.VersionedNotebookDocumentIdentifier The notebook document that did change. The version number points<br>to the version after all provided changes have been applied. If<br>only the text document content of a cell changes the notebook version<br>doesn't necessarily have to change.
---@field public change insx.kit.LSP.NotebookDocumentChangeEvent The actual changes to the notebook document.<br><br>The changes describe single state changes to the notebook document.<br>So if there are two changes c1 (at array index 0) and c2 (at array<br>index 1) for a notebook in state S then c1 moves the notebook from<br>S to S' and c2 from S' to S''. So c1 is computed on the state S and<br>c2 is computed on the state S'.<br><br>To mirror the content of a notebook using change events use the following approach:<br>- start with the same initial content<br>- apply the 'notebookDocument/didChange' notifications in the order you receive them.<br>- apply the `NotebookChangeEvent`s in a single notification in the order<br>  you receive them.

---@class insx.kit.LSP.DidSaveNotebookDocumentParams
---@field public notebookDocument insx.kit.LSP.NotebookDocumentIdentifier The notebook document that got saved.

---@class insx.kit.LSP.DidCloseNotebookDocumentParams
---@field public notebookDocument insx.kit.LSP.NotebookDocumentIdentifier The notebook document that got closed.
---@field public cellTextDocuments insx.kit.LSP.TextDocumentIdentifier[] The text documents that represent the content<br>of a notebook cell that got closed.

---@class insx.kit.LSP.RegistrationParams
---@field public registrations insx.kit.LSP.Registration[]

---@class insx.kit.LSP.UnregistrationParams
---@field public unregisterations insx.kit.LSP.Unregistration[]

---@class insx.kit.LSP.InitializeParams : insx.kit.LSP._InitializeParams, insx.kit.LSP.WorkspaceFoldersInitializeParams

---@class insx.kit.LSP.InitializeResult
---@field public capabilities insx.kit.LSP.ServerCapabilities The capabilities the language server provides.
---@field public serverInfo? insx.kit.LSP.InitializeResult.serverInfo Information about the server.<br><br>@since 3.15.0

---@class insx.kit.LSP.InitializeResult.serverInfo
---@field public name string The name of the server as defined by the server.
---@field public version? string The server's version as defined by the server.

---@class insx.kit.LSP.InitializeError
---@field public retry boolean Indicates whether the client execute the following retry logic:<br>(1) show the message provided by the ResponseError to the user<br>(2) user selects retry or cancel<br>(3) if user selected retry the initialize method is sent again.

---@class insx.kit.LSP.InitializedParams

---@class insx.kit.LSP.DidChangeConfigurationParams
---@field public settings insx.kit.LSP.LSPAny The actual changed settings

---@class insx.kit.LSP.DidChangeConfigurationRegistrationOptions
---@field public section? (string | string[])

---@class insx.kit.LSP.ShowMessageParams
---@field public type insx.kit.LSP.MessageType The message type. See {@link MessageType}
---@field public message string The actual message.

---@class insx.kit.LSP.ShowMessageRequestParams
---@field public type insx.kit.LSP.MessageType The message type. See {@link MessageType}
---@field public message string The actual message.
---@field public actions? insx.kit.LSP.MessageActionItem[] The message action items to present.

---@class insx.kit.LSP.MessageActionItem
---@field public title string A short title like 'Retry', 'Open Log' etc.

---@class insx.kit.LSP.LogMessageParams
---@field public type insx.kit.LSP.MessageType The message type. See {@link MessageType}
---@field public message string The actual message.

---@class insx.kit.LSP.DidOpenTextDocumentParams
---@field public textDocument insx.kit.LSP.TextDocumentItem The document that was opened.

---@class insx.kit.LSP.DidChangeTextDocumentParams
---@field public textDocument insx.kit.LSP.VersionedTextDocumentIdentifier The document that did change. The version number points<br>to the version after all provided content changes have<br>been applied.
---@field public contentChanges insx.kit.LSP.TextDocumentContentChangeEvent[] The actual content changes. The content changes describe single state changes<br>to the document. So if there are two content changes c1 (at array index 0) and<br>c2 (at array index 1) for a document in state S then c1 moves the document from<br>S to S' and c2 from S' to S''. So c1 is computed on the state S and c2 is computed<br>on the state S'.<br><br>To mirror the content of a document using change events use the following approach:<br>- start with the same initial content<br>- apply the 'textDocument/didChange' notifications in the order you receive them.<br>- apply the `TextDocumentContentChangeEvent`s in a single notification in the order<br>  you receive them.

---@class insx.kit.LSP.TextDocumentChangeRegistrationOptions : insx.kit.LSP.TextDocumentRegistrationOptions
---@field public syncKind insx.kit.LSP.TextDocumentSyncKind How documents are synced to the server.

---@class insx.kit.LSP.DidCloseTextDocumentParams
---@field public textDocument insx.kit.LSP.TextDocumentIdentifier The document that was closed.

---@class insx.kit.LSP.DidSaveTextDocumentParams
---@field public textDocument insx.kit.LSP.TextDocumentIdentifier The document that was saved.
---@field public text? string Optional the content when saved. Depends on the includeText value<br>when the save notification was requested.

---@class insx.kit.LSP.TextDocumentSaveRegistrationOptions : insx.kit.LSP.TextDocumentRegistrationOptions, insx.kit.LSP.SaveOptions

---@class insx.kit.LSP.WillSaveTextDocumentParams
---@field public textDocument insx.kit.LSP.TextDocumentIdentifier The document that will be saved.
---@field public reason insx.kit.LSP.TextDocumentSaveReason The 'TextDocumentSaveReason'.

---@class insx.kit.LSP.TextEdit
---@field public range insx.kit.LSP.Range The range of the text document to be manipulated. To insert<br>text into a document create a range where start === end.
---@field public newText string The string to be inserted. For delete operations use an<br>empty string.

---@class insx.kit.LSP.DidChangeWatchedFilesParams
---@field public changes insx.kit.LSP.FileEvent[] The actual file events.

---@class insx.kit.LSP.DidChangeWatchedFilesRegistrationOptions
---@field public watchers insx.kit.LSP.FileSystemWatcher[] The watchers to register.

---@class insx.kit.LSP.PublishDiagnosticsParams
---@field public uri string The URI for which diagnostic information is reported.
---@field public version? integer Optional the version number of the document the diagnostics are published for.<br><br>@since 3.15.0
---@field public diagnostics insx.kit.LSP.Diagnostic[] An array of diagnostic information items.

---@class insx.kit.LSP.CompletionParams : insx.kit.LSP.TextDocumentPositionParams, insx.kit.LSP.WorkDoneProgressParams, insx.kit.LSP.PartialResultParams
---@field public context? insx.kit.LSP.CompletionContext The completion context. This is only available it the client specifies<br>to send this using the client capability `textDocument.completion.contextSupport === true`

---@class insx.kit.LSP.CompletionItem
---@field public label string The label of this completion item.<br><br>The label property is also by default the text that<br>is inserted when selecting this completion.<br><br>If label details are provided the label itself should<br>be an unqualified name of the completion item.
---@field public labelDetails? insx.kit.LSP.CompletionItemLabelDetails Additional details for the label<br><br>@since 3.17.0
---@field public kind? insx.kit.LSP.CompletionItemKind The kind of this completion item. Based of the kind<br>an icon is chosen by the editor.
---@field public tags? insx.kit.LSP.CompletionItemTag[] Tags for this completion item.<br><br>@since 3.15.0
---@field public detail? string A human-readable string with additional information<br>about this item, like type or symbol information.
---@field public documentation? (string | insx.kit.LSP.MarkupContent) A human-readable string that represents a doc-comment.
---@field public deprecated? boolean Indicates if this item is deprecated.<br>@deprecated Use `tags` instead.
---@field public preselect? boolean Select this item when showing.<br><br>*Note* that only one completion item can be selected and that the<br>tool / client decides which item that is. The rule is that the *first*<br>item of those that match best is selected.
---@field public sortText? string A string that should be used when comparing this item<br>with other items. When `falsy` the [label](#CompletionItem.label)<br>is used.
---@field public filterText? string A string that should be used when filtering a set of<br>completion items. When `falsy` the [label](#CompletionItem.label)<br>is used.
---@field public insertText? string A string that should be inserted into a document when selecting<br>this completion. When `falsy` the [label](#CompletionItem.label)<br>is used.<br><br>The `insertText` is subject to interpretation by the client side.<br>Some tools might not take the string literally. For example<br>VS Code when code complete is requested in this example<br>`con<cursor position>` and a completion item with an `insertText` of<br>`console` is provided it will only insert `sole`. Therefore it is<br>recommended to use `textEdit` instead since it avoids additional client<br>side interpretation.
---@field public insertTextFormat? insx.kit.LSP.InsertTextFormat The format of the insert text. The format applies to both the<br>`insertText` property and the `newText` property of a provided<br>`textEdit`. If omitted defaults to `InsertTextFormat.PlainText`.<br><br>Please note that the insertTextFormat doesn't apply to<br>`additionalTextEdits`.
---@field public insertTextMode? insx.kit.LSP.InsertTextMode How whitespace and indentation is handled during completion<br>item insertion. If not provided the clients default value depends on<br>the `textDocument.completion.insertTextMode` client capability.<br><br>@since 3.16.0
---@field public textEdit? (insx.kit.LSP.TextEdit | insx.kit.LSP.InsertReplaceEdit) An [edit](#TextEdit) which is applied to a document when selecting<br>this completion. When an edit is provided the value of<br>[insertText](#CompletionItem.insertText) is ignored.<br><br>Most editors support two different operations when accepting a completion<br>item. One is to insert a completion text and the other is to replace an<br>existing text with a completion text. Since this can usually not be<br>predetermined by a server it can report both ranges. Clients need to<br>signal support for `InsertReplaceEdits` via the<br>`textDocument.completion.insertReplaceSupport` client capability<br>property.<br><br>*Note 1:* The text edit's range as well as both ranges from an insert<br>replace edit must be a [single line] and they must contain the position<br>at which completion has been requested.<br>*Note 2:* If an `InsertReplaceEdit` is returned the edit's insert range<br>must be a prefix of the edit's replace range, that means it must be<br>contained and starting at the same position.<br><br>@since 3.16.0 additional type `InsertReplaceEdit`
---@field public textEditText? string The edit text used if the completion item is part of a CompletionList and<br>CompletionList defines an item default for the text edit range.<br><br>Clients will only honor this property if they opt into completion list<br>item defaults using the capability `completionList.itemDefaults`.<br><br>If not provided and a list's default range is provided the label<br>property is used as a text.<br><br>@since 3.17.0
---@field public additionalTextEdits? insx.kit.LSP.TextEdit[] An optional array of additional [text edits](#TextEdit) that are applied when<br>selecting this completion. Edits must not overlap (including the same insert position)<br>with the main [edit](#CompletionItem.textEdit) nor with themselves.<br><br>Additional text edits should be used to change text unrelated to the current cursor position<br>(for example adding an import statement at the top of the file if the completion item will<br>insert an unqualified type).
---@field public commitCharacters? string[] An optional set of characters that when pressed while this completion is active will accept it first and<br>then type that character. *Note* that all commit characters should have `length=1` and that superfluous<br>characters will be ignored.
---@field public command? insx.kit.LSP.Command An optional [command](#Command) that is executed *after* inserting this completion. *Note* that<br>additional modifications to the current document should be described with the<br>[additionalTextEdits](#CompletionItem.additionalTextEdits)-property.
---@field public data? insx.kit.LSP.LSPAny A data entry field that is preserved on a completion item between a<br>[CompletionRequest](#CompletionRequest) and a [CompletionResolveRequest](#CompletionResolveRequest).

---@class insx.kit.LSP.CompletionList
---@field public isIncomplete boolean This list it not complete. Further typing results in recomputing this list.<br><br>Recomputed lists have all their items replaced (not appended) in the<br>incomplete completion sessions.
---@field public itemDefaults? insx.kit.LSP.CompletionList.itemDefaults In many cases the items of an actual completion result share the same<br>value for properties like `commitCharacters` or the range of a text<br>edit. A completion list can therefore define item defaults which will<br>be used if a completion item itself doesn't specify the value.<br><br>If a completion list specifies a default value and a completion item<br>also specifies a corresponding value the one from the item is used.<br><br>Servers are only allowed to return default values if the client<br>signals support for this via the `completionList.itemDefaults`<br>capability.<br><br>@since 3.17.0
---@field public items insx.kit.LSP.CompletionItem[] The completion items.

---@class insx.kit.LSP.CompletionList.itemDefaults
---@field public commitCharacters? string[] A default commit character set.<br><br>@since 3.17.0
---@field public editRange? (insx.kit.LSP.Range | { insert: insx.kit.LSP.Range, replace: insx.kit.LSP.Range }) A default edit range.<br><br>@since 3.17.0
---@field public insertTextFormat? insx.kit.LSP.InsertTextFormat A default insert text format.<br><br>@since 3.17.0
---@field public insertTextMode? insx.kit.LSP.InsertTextMode A default insert text mode.<br><br>@since 3.17.0
---@field public data? insx.kit.LSP.LSPAny A default data value.<br><br>@since 3.17.0

---@class insx.kit.LSP.CompletionRegistrationOptions : insx.kit.LSP.TextDocumentRegistrationOptions, insx.kit.LSP.CompletionOptions

---@class insx.kit.LSP.HoverParams : insx.kit.LSP.TextDocumentPositionParams, insx.kit.LSP.WorkDoneProgressParams

---@class insx.kit.LSP.Hover
---@field public contents (insx.kit.LSP.MarkupContent | insx.kit.LSP.MarkedString | insx.kit.LSP.MarkedString[]) The hover's content
---@field public range? insx.kit.LSP.Range An optional range inside the text document that is used to<br>visualize the hover, e.g. by changing the background color.

---@class insx.kit.LSP.HoverRegistrationOptions : insx.kit.LSP.TextDocumentRegistrationOptions, insx.kit.LSP.HoverOptions

---@class insx.kit.LSP.SignatureHelpParams : insx.kit.LSP.TextDocumentPositionParams, insx.kit.LSP.WorkDoneProgressParams
---@field public context? insx.kit.LSP.SignatureHelpContext The signature help context. This is only available if the client specifies<br>to send this using the client capability `textDocument.signatureHelp.contextSupport === true`<br><br>@since 3.15.0

---@class insx.kit.LSP.SignatureHelp
---@field public signatures insx.kit.LSP.SignatureInformation[] One or more signatures.
---@field public activeSignature? integer The active signature. If omitted or the value lies outside the<br>range of `signatures` the value defaults to zero or is ignored if<br>the `SignatureHelp` has no signatures.<br><br>Whenever possible implementors should make an active decision about<br>the active signature and shouldn't rely on a default value.<br><br>In future version of the protocol this property might become<br>mandatory to better express this.
---@field public activeParameter? integer The active parameter of the active signature. If omitted or the value<br>lies outside the range of `signatures[activeSignature].parameters`<br>defaults to 0 if the active signature has parameters. If<br>the active signature has no parameters it is ignored.<br>In future version of the protocol this property might become<br>mandatory to better express the active parameter if the<br>active signature does have any.

---@class insx.kit.LSP.SignatureHelpRegistrationOptions : insx.kit.LSP.TextDocumentRegistrationOptions, insx.kit.LSP.SignatureHelpOptions

---@class insx.kit.LSP.DefinitionParams : insx.kit.LSP.TextDocumentPositionParams, insx.kit.LSP.WorkDoneProgressParams, insx.kit.LSP.PartialResultParams

---@class insx.kit.LSP.DefinitionRegistrationOptions : insx.kit.LSP.TextDocumentRegistrationOptions, insx.kit.LSP.DefinitionOptions

---@class insx.kit.LSP.ReferenceParams : insx.kit.LSP.TextDocumentPositionParams, insx.kit.LSP.WorkDoneProgressParams, insx.kit.LSP.PartialResultParams
---@field public context insx.kit.LSP.ReferenceContext

---@class insx.kit.LSP.ReferenceRegistrationOptions : insx.kit.LSP.TextDocumentRegistrationOptions, insx.kit.LSP.ReferenceOptions

---@class insx.kit.LSP.DocumentHighlightParams : insx.kit.LSP.TextDocumentPositionParams, insx.kit.LSP.WorkDoneProgressParams, insx.kit.LSP.PartialResultParams

---@class insx.kit.LSP.DocumentHighlight
---@field public range insx.kit.LSP.Range The range this highlight applies to.
---@field public kind? insx.kit.LSP.DocumentHighlightKind The highlight kind, default is [text](#DocumentHighlightKind.Text).

---@class insx.kit.LSP.DocumentHighlightRegistrationOptions : insx.kit.LSP.TextDocumentRegistrationOptions, insx.kit.LSP.DocumentHighlightOptions

---@class insx.kit.LSP.DocumentSymbolParams : insx.kit.LSP.WorkDoneProgressParams, insx.kit.LSP.PartialResultParams
---@field public textDocument insx.kit.LSP.TextDocumentIdentifier The text document.

---@class insx.kit.LSP.SymbolInformation : insx.kit.LSP.BaseSymbolInformation
---@field public deprecated? boolean Indicates if this symbol is deprecated.<br><br>@deprecated Use tags instead
---@field public location insx.kit.LSP.Location The location of this symbol. The location's range is used by a tool<br>to reveal the location in the editor. If the symbol is selected in the<br>tool the range's start information is used to position the cursor. So<br>the range usually spans more than the actual symbol's name and does<br>normally include things like visibility modifiers.<br><br>The range doesn't have to denote a node range in the sense of an abstract<br>syntax tree. It can therefore not be used to re-construct a hierarchy of<br>the symbols.

---@class insx.kit.LSP.DocumentSymbol
---@field public name string The name of this symbol. Will be displayed in the user interface and therefore must not be<br>an empty string or a string only consisting of white spaces.
---@field public detail? string More detail for this symbol, e.g the signature of a function.
---@field public kind insx.kit.LSP.SymbolKind The kind of this symbol.
---@field public tags? insx.kit.LSP.SymbolTag[] Tags for this document symbol.<br><br>@since 3.16.0
---@field public deprecated? boolean Indicates if this symbol is deprecated.<br><br>@deprecated Use tags instead
---@field public range insx.kit.LSP.Range The range enclosing this symbol not including leading/trailing whitespace but everything else<br>like comments. This information is typically used to determine if the clients cursor is<br>inside the symbol to reveal in the symbol in the UI.
---@field public selectionRange insx.kit.LSP.Range The range that should be selected and revealed when this symbol is being picked, e.g the name of a function.<br>Must be contained by the `range`.
---@field public children? insx.kit.LSP.DocumentSymbol[] Children of this symbol, e.g. properties of a class.

---@class insx.kit.LSP.DocumentSymbolRegistrationOptions : insx.kit.LSP.TextDocumentRegistrationOptions, insx.kit.LSP.DocumentSymbolOptions

---@class insx.kit.LSP.CodeActionParams : insx.kit.LSP.WorkDoneProgressParams, insx.kit.LSP.PartialResultParams
---@field public textDocument insx.kit.LSP.TextDocumentIdentifier The document in which the command was invoked.
---@field public range insx.kit.LSP.Range The range for which the command was invoked.
---@field public context insx.kit.LSP.CodeActionContext Context carrying additional information.

---@class insx.kit.LSP.Command
---@field public title string Title of the command, like `save`.
---@field public command string The identifier of the actual command handler.
---@field public arguments? insx.kit.LSP.LSPAny[] Arguments that the command handler should be<br>invoked with.

---@class insx.kit.LSP.CodeAction
---@field public title string A short, human-readable, title for this code action.
---@field public kind? insx.kit.LSP.CodeActionKind The kind of the code action.<br><br>Used to filter code actions.
---@field public diagnostics? insx.kit.LSP.Diagnostic[] The diagnostics that this code action resolves.
---@field public isPreferred? boolean Marks this as a preferred action. Preferred actions are used by the `auto fix` command and can be targeted<br>by keybindings.<br><br>A quick fix should be marked preferred if it properly addresses the underlying error.<br>A refactoring should be marked preferred if it is the most reasonable choice of actions to take.<br><br>@since 3.15.0
---@field public disabled? insx.kit.LSP.CodeAction.disabled Marks that the code action cannot currently be applied.<br><br>Clients should follow the following guidelines regarding disabled code actions:<br><br>  - Disabled code actions are not shown in automatic [lightbulbs](https://code.visualstudio.com/docs/editor/editingevolved#_code-action)<br>    code action menus.<br><br>  - Disabled actions are shown as faded out in the code action menu when the user requests a more specific type<br>    of code action, such as refactorings.<br><br>  - If the user has a [keybinding](https://code.visualstudio.com/docs/editor/refactoring#_keybindings-for-code-actions)<br>    that auto applies a code action and only disabled code actions are returned, the client should show the user an<br>    error message with `reason` in the editor.<br><br>@since 3.16.0
---@field public edit? insx.kit.LSP.WorkspaceEdit The workspace edit this code action performs.
---@field public command? insx.kit.LSP.Command A command this code action executes. If a code action<br>provides an edit and a command, first the edit is<br>executed and then the command.
---@field public data? insx.kit.LSP.LSPAny A data entry field that is preserved on a code action between<br>a `textDocument/codeAction` and a `codeAction/resolve` request.<br><br>@since 3.16.0

---@class insx.kit.LSP.CodeAction.disabled
---@field public reason string Human readable description of why the code action is currently disabled.<br><br>This is displayed in the code actions UI.

---@class insx.kit.LSP.CodeActionRegistrationOptions : insx.kit.LSP.TextDocumentRegistrationOptions, insx.kit.LSP.CodeActionOptions

---@class insx.kit.LSP.WorkspaceSymbolParams : insx.kit.LSP.WorkDoneProgressParams, insx.kit.LSP.PartialResultParams
---@field public query string A query string to filter symbols by. Clients may send an empty<br>string here to request all symbols.

---@class insx.kit.LSP.WorkspaceSymbol : insx.kit.LSP.BaseSymbolInformation
---@field public location (insx.kit.LSP.Location | { uri: string }) The location of the symbol. Whether a server is allowed to<br>return a location without a range depends on the client<br>capability `workspace.symbol.resolveSupport`.<br><br>See SymbolInformation#location for more details.
---@field public data? insx.kit.LSP.LSPAny A data entry field that is preserved on a workspace symbol between a<br>workspace symbol request and a workspace symbol resolve request.

---@class insx.kit.LSP.WorkspaceSymbolRegistrationOptions : insx.kit.LSP.WorkspaceSymbolOptions

---@class insx.kit.LSP.CodeLensParams : insx.kit.LSP.WorkDoneProgressParams, insx.kit.LSP.PartialResultParams
---@field public textDocument insx.kit.LSP.TextDocumentIdentifier The document to request code lens for.

---@class insx.kit.LSP.CodeLens
---@field public range insx.kit.LSP.Range The range in which this code lens is valid. Should only span a single line.
---@field public command? insx.kit.LSP.Command The command this code lens represents.
---@field public data? insx.kit.LSP.LSPAny A data entry field that is preserved on a code lens item between<br>a [CodeLensRequest](#CodeLensRequest) and a [CodeLensResolveRequest]<br>(#CodeLensResolveRequest)

---@class insx.kit.LSP.CodeLensRegistrationOptions : insx.kit.LSP.TextDocumentRegistrationOptions, insx.kit.LSP.CodeLensOptions

---@class insx.kit.LSP.DocumentLinkParams : insx.kit.LSP.WorkDoneProgressParams, insx.kit.LSP.PartialResultParams
---@field public textDocument insx.kit.LSP.TextDocumentIdentifier The document to provide document links for.

---@class insx.kit.LSP.DocumentLink
---@field public range insx.kit.LSP.Range The range this link applies to.
---@field public target? string The uri this link points to. If missing a resolve request is sent later.
---@field public tooltip? string The tooltip text when you hover over this link.<br><br>If a tooltip is provided, is will be displayed in a string that includes instructions on how to<br>trigger the link, such as `{0} (ctrl + click)`. The specific instructions vary depending on OS,<br>user settings, and localization.<br><br>@since 3.15.0
---@field public data? insx.kit.LSP.LSPAny A data entry field that is preserved on a document link between a<br>DocumentLinkRequest and a DocumentLinkResolveRequest.

---@class insx.kit.LSP.DocumentLinkRegistrationOptions : insx.kit.LSP.TextDocumentRegistrationOptions, insx.kit.LSP.DocumentLinkOptions

---@class insx.kit.LSP.DocumentFormattingParams : insx.kit.LSP.WorkDoneProgressParams
---@field public textDocument insx.kit.LSP.TextDocumentIdentifier The document to format.
---@field public options insx.kit.LSP.FormattingOptions The format options.

---@class insx.kit.LSP.DocumentFormattingRegistrationOptions : insx.kit.LSP.TextDocumentRegistrationOptions, insx.kit.LSP.DocumentFormattingOptions

---@class insx.kit.LSP.DocumentRangeFormattingParams : insx.kit.LSP.WorkDoneProgressParams
---@field public textDocument insx.kit.LSP.TextDocumentIdentifier The document to format.
---@field public range insx.kit.LSP.Range The range to format
---@field public options insx.kit.LSP.FormattingOptions The format options

---@class insx.kit.LSP.DocumentRangeFormattingRegistrationOptions : insx.kit.LSP.TextDocumentRegistrationOptions, insx.kit.LSP.DocumentRangeFormattingOptions

---@class insx.kit.LSP.DocumentOnTypeFormattingParams
---@field public textDocument insx.kit.LSP.TextDocumentIdentifier The document to format.
---@field public position insx.kit.LSP.Position The position around which the on type formatting should happen.<br>This is not necessarily the exact position where the character denoted<br>by the property `ch` got typed.
---@field public ch string The character that has been typed that triggered the formatting<br>on type request. That is not necessarily the last character that<br>got inserted into the document since the client could auto insert<br>characters as well (e.g. like automatic brace completion).
---@field public options insx.kit.LSP.FormattingOptions The formatting options.

---@class insx.kit.LSP.DocumentOnTypeFormattingRegistrationOptions : insx.kit.LSP.TextDocumentRegistrationOptions, insx.kit.LSP.DocumentOnTypeFormattingOptions

---@class insx.kit.LSP.RenameParams : insx.kit.LSP.WorkDoneProgressParams
---@field public textDocument insx.kit.LSP.TextDocumentIdentifier The document to rename.
---@field public position insx.kit.LSP.Position The position at which this request was sent.
---@field public newName string The new name of the symbol. If the given name is not valid the<br>request must return a [ResponseError](#ResponseError) with an<br>appropriate message set.

---@class insx.kit.LSP.RenameRegistrationOptions : insx.kit.LSP.TextDocumentRegistrationOptions, insx.kit.LSP.RenameOptions

---@class insx.kit.LSP.PrepareRenameParams : insx.kit.LSP.TextDocumentPositionParams, insx.kit.LSP.WorkDoneProgressParams

---@class insx.kit.LSP.ExecuteCommandParams : insx.kit.LSP.WorkDoneProgressParams
---@field public command string The identifier of the actual command handler.
---@field public arguments? insx.kit.LSP.LSPAny[] Arguments that the command should be invoked with.

---@class insx.kit.LSP.ExecuteCommandRegistrationOptions : insx.kit.LSP.ExecuteCommandOptions

---@class insx.kit.LSP.ApplyWorkspaceEditParams
---@field public label? string An optional label of the workspace edit. This label is<br>presented in the user interface for example on an undo<br>stack to undo the workspace edit.
---@field public edit insx.kit.LSP.WorkspaceEdit The edits to apply.

---@class insx.kit.LSP.ApplyWorkspaceEditResult
---@field public applied boolean Indicates whether the edit was applied or not.
---@field public failureReason? string An optional textual description for why the edit was not applied.<br>This may be used by the server for diagnostic logging or to provide<br>a suitable error for a request that triggered the edit.
---@field public failedChange? integer Depending on the client's failure handling strategy `failedChange` might<br>contain the index of the change that failed. This property is only available<br>if the client signals a `failureHandlingStrategy` in its client capabilities.

---@class insx.kit.LSP.WorkDoneProgressBegin
---@field public kind "begin"
---@field public title string Mandatory title of the progress operation. Used to briefly inform about<br>the kind of operation being performed.<br><br>Examples: "Indexing" or "Linking dependencies".
---@field public cancellable? boolean Controls if a cancel button should show to allow the user to cancel the<br>long running operation. Clients that don't support cancellation are allowed<br>to ignore the setting.
---@field public message? string Optional, more detailed associated progress message. Contains<br>complementary information to the `title`.<br><br>Examples: "3/25 files", "project/src/module2", "node_modules/some_dep".<br>If unset, the previous progress message (if any) is still valid.
---@field public percentage? integer Optional progress percentage to display (value 100 is considered 100%).<br>If not provided infinite progress is assumed and clients are allowed<br>to ignore the `percentage` value in subsequent in report notifications.<br><br>The value should be steadily rising. Clients are free to ignore values<br>that are not following this rule. The value range is [0, 100].

---@class insx.kit.LSP.WorkDoneProgressReport
---@field public kind "report"
---@field public cancellable? boolean Controls enablement state of a cancel button.<br><br>Clients that don't support cancellation or don't support controlling the button's<br>enablement state are allowed to ignore the property.
---@field public message? string Optional, more detailed associated progress message. Contains<br>complementary information to the `title`.<br><br>Examples: "3/25 files", "project/src/module2", "node_modules/some_dep".<br>If unset, the previous progress message (if any) is still valid.
---@field public percentage? integer Optional progress percentage to display (value 100 is considered 100%).<br>If not provided infinite progress is assumed and clients are allowed<br>to ignore the `percentage` value in subsequent in report notifications.<br><br>The value should be steadily rising. Clients are free to ignore values<br>that are not following this rule. The value range is [0, 100]

---@class insx.kit.LSP.WorkDoneProgressEnd
---@field public kind "end"
---@field public message? string Optional, a final message indicating to for example indicate the outcome<br>of the operation.

---@class insx.kit.LSP.SetTraceParams
---@field public value insx.kit.LSP.TraceValues

---@class insx.kit.LSP.LogTraceParams
---@field public message string
---@field public verbose? string

---@class insx.kit.LSP.CancelParams
---@field public id (integer | string) The request id to cancel.

---@class insx.kit.LSP.ProgressParams
---@field public token insx.kit.LSP.ProgressToken The progress token provided by the client or server.
---@field public value insx.kit.LSP.LSPAny The progress data.

---@class insx.kit.LSP.TextDocumentPositionParams
---@field public textDocument insx.kit.LSP.TextDocumentIdentifier The text document.
---@field public position insx.kit.LSP.Position The position inside the text document.

---@class insx.kit.LSP.WorkDoneProgressParams
---@field public workDoneToken? insx.kit.LSP.ProgressToken An optional token that a server can use to report work done progress.

---@class insx.kit.LSP.LocationLink
---@field public originSelectionRange? insx.kit.LSP.Range Span of the origin of this link.<br><br>Used as the underlined span for mouse interaction. Defaults to the word range at<br>the definition position.
---@field public targetUri string The target resource identifier of this link.
---@field public targetRange insx.kit.LSP.Range The full target range of this link. If the target for example is a symbol then target range is the<br>range enclosing this symbol not including leading/trailing whitespace but everything else<br>like comments. This information is typically used to highlight the range in the editor.
---@field public targetSelectionRange insx.kit.LSP.Range The range that should be selected and revealed when this link is being followed, e.g the name of a function.<br>Must be contained by the `targetRange`. See also `DocumentSymbol#range`

---@class insx.kit.LSP.Range
---@field public start insx.kit.LSP.Position The range's start position.
---@field public end insx.kit.LSP.Position The range's end position.

---@class insx.kit.LSP.ImplementationOptions : insx.kit.LSP.WorkDoneProgressOptions

---@class insx.kit.LSP.StaticRegistrationOptions
---@field public id? string The id used to register the request. The id can be used to deregister<br>the request again. See also Registration#id.

---@class insx.kit.LSP.TypeDefinitionOptions : insx.kit.LSP.WorkDoneProgressOptions

---@class insx.kit.LSP.WorkspaceFoldersChangeEvent
---@field public added insx.kit.LSP.WorkspaceFolder[] The array of added workspace folders
---@field public removed insx.kit.LSP.WorkspaceFolder[] The array of the removed workspace folders

---@class insx.kit.LSP.ConfigurationItem
---@field public scopeUri? string The scope to get the configuration section for.
---@field public section? string The configuration section asked for.

---@class insx.kit.LSP.TextDocumentIdentifier
---@field public uri string The text document's uri.

---@class insx.kit.LSP.Color
---@field public red integer The red component of this color in the range [0-1].
---@field public green integer The green component of this color in the range [0-1].
---@field public blue integer The blue component of this color in the range [0-1].
---@field public alpha integer The alpha component of this color in the range [0-1].

---@class insx.kit.LSP.DocumentColorOptions : insx.kit.LSP.WorkDoneProgressOptions

---@class insx.kit.LSP.FoldingRangeOptions : insx.kit.LSP.WorkDoneProgressOptions

---@class insx.kit.LSP.DeclarationOptions : insx.kit.LSP.WorkDoneProgressOptions

---@class insx.kit.LSP.Position
---@field public line integer Line position in a document (zero-based).<br><br>If a line number is greater than the number of lines in a document, it defaults back to the number of lines in the document.<br>If a line number is negative, it defaults to 0.
---@field public character integer Character offset on a line in a document (zero-based).<br><br>The meaning of this offset is determined by the negotiated<br>`PositionEncodingKind`.<br><br>If the character value is greater than the line length it defaults back to the<br>line length.

---@class insx.kit.LSP.SelectionRangeOptions : insx.kit.LSP.WorkDoneProgressOptions

---@class insx.kit.LSP.CallHierarchyOptions : insx.kit.LSP.WorkDoneProgressOptions

---@class insx.kit.LSP.SemanticTokensOptions : insx.kit.LSP.WorkDoneProgressOptions
---@field public legend insx.kit.LSP.SemanticTokensLegend The legend used by the server
---@field public range? (boolean | {  }) Server supports providing semantic tokens for a specific range<br>of a document.
---@field public full? (boolean | { delta?: boolean }) Server supports providing semantic tokens for a full document.

---@class insx.kit.LSP.SemanticTokensEdit
---@field public start integer The start offset of the edit.
---@field public deleteCount integer The count of elements to remove.
---@field public data? integer[] The elements to insert.

---@class insx.kit.LSP.LinkedEditingRangeOptions : insx.kit.LSP.WorkDoneProgressOptions

---@class insx.kit.LSP.FileCreate
---@field public uri string A file:// URI for the location of the file/folder being created.

---@class insx.kit.LSP.TextDocumentEdit
---@field public textDocument insx.kit.LSP.OptionalVersionedTextDocumentIdentifier The text document to change.
---@field public edits (insx.kit.LSP.TextEdit | insx.kit.LSP.AnnotatedTextEdit)[] The edits to be applied.<br><br>@since 3.16.0 - support for AnnotatedTextEdit. This is guarded using a<br>client capability.

---@class insx.kit.LSP.CreateFile : insx.kit.LSP.ResourceOperation
---@field public kind "create" A create
---@field public uri string The resource to create.
---@field public options? insx.kit.LSP.CreateFileOptions Additional options

---@class insx.kit.LSP.RenameFile : insx.kit.LSP.ResourceOperation
---@field public kind "rename" A rename
---@field public oldUri string The old (existing) location.
---@field public newUri string The new location.
---@field public options? insx.kit.LSP.RenameFileOptions Rename options.

---@class insx.kit.LSP.DeleteFile : insx.kit.LSP.ResourceOperation
---@field public kind "delete" A delete
---@field public uri string The file to delete.
---@field public options? insx.kit.LSP.DeleteFileOptions Delete options.

---@class insx.kit.LSP.ChangeAnnotation
---@field public label string A human-readable string describing the actual change. The string<br>is rendered prominent in the user interface.
---@field public needsConfirmation? boolean A flag which indicates that user confirmation is needed<br>before applying the change.
---@field public description? string A human-readable string which is rendered less prominent in<br>the user interface.

---@class insx.kit.LSP.FileOperationFilter
---@field public scheme? string A Uri scheme like `file` or `untitled`.
---@field public pattern insx.kit.LSP.FileOperationPattern The actual file operation pattern.

---@class insx.kit.LSP.FileRename
---@field public oldUri string A file:// URI for the original location of the file/folder being renamed.
---@field public newUri string A file:// URI for the new location of the file/folder being renamed.

---@class insx.kit.LSP.FileDelete
---@field public uri string A file:// URI for the location of the file/folder being deleted.

---@class insx.kit.LSP.MonikerOptions : insx.kit.LSP.WorkDoneProgressOptions

---@class insx.kit.LSP.TypeHierarchyOptions : insx.kit.LSP.WorkDoneProgressOptions

---@class insx.kit.LSP.InlineValueContext
---@field public frameId integer The stack frame (as a DAP Id) where the execution has stopped.
---@field public stoppedLocation insx.kit.LSP.Range The document range where execution has stopped.<br>Typically the end position of the range denotes the line where the inline values are shown.

---@class insx.kit.LSP.InlineValueText
---@field public range insx.kit.LSP.Range The document range for which the inline value applies.
---@field public text string The text of the inline value.

---@class insx.kit.LSP.InlineValueVariableLookup
---@field public range insx.kit.LSP.Range The document range for which the inline value applies.<br>The range is used to extract the variable name from the underlying document.
---@field public variableName? string If specified the name of the variable to look up.
---@field public caseSensitiveLookup boolean How to perform the lookup.

---@class insx.kit.LSP.InlineValueEvaluatableExpression
---@field public range insx.kit.LSP.Range The document range for which the inline value applies.<br>The range is used to extract the evaluatable expression from the underlying document.
---@field public expression? string If specified the expression overrides the extracted expression.

---@class insx.kit.LSP.InlineValueOptions : insx.kit.LSP.WorkDoneProgressOptions

---@class insx.kit.LSP.InlayHintLabelPart
---@field public value string The value of this label part.
---@field public tooltip? (string | insx.kit.LSP.MarkupContent) The tooltip text when you hover over this label part. Depending on<br>the client capability `inlayHint.resolveSupport` clients might resolve<br>this property late using the resolve request.
---@field public location? insx.kit.LSP.Location An optional source code location that represents this<br>label part.<br><br>The editor will use this location for the hover and for code navigation<br>features: This part will become a clickable link that resolves to the<br>definition of the symbol at the given location (not necessarily the<br>location itself), it shows the hover that shows at the given location,<br>and it shows a context menu with further code navigation commands.<br><br>Depending on the client capability `inlayHint.resolveSupport` clients<br>might resolve this property late using the resolve request.
---@field public command? insx.kit.LSP.Command An optional command for this label part.<br><br>Depending on the client capability `inlayHint.resolveSupport` clients<br>might resolve this property late using the resolve request.

---@class insx.kit.LSP.MarkupContent
---@field public kind insx.kit.LSP.MarkupKind The type of the Markup
---@field public value string The content itself

---@class insx.kit.LSP.InlayHintOptions : insx.kit.LSP.WorkDoneProgressOptions
---@field public resolveProvider? boolean The server provides support to resolve additional<br>information for an inlay hint item.

---@class insx.kit.LSP.RelatedFullDocumentDiagnosticReport : insx.kit.LSP.FullDocumentDiagnosticReport
---@field public relatedDocuments? table<string, (insx.kit.LSP.FullDocumentDiagnosticReport | insx.kit.LSP.UnchangedDocumentDiagnosticReport)> Diagnostics of related documents. This information is useful<br>in programming languages where code in a file A can generate<br>diagnostics in a file B which A depends on. An example of<br>such a language is C/C++ where marco definitions in a file<br>a.cpp and result in errors in a header file b.hpp.<br><br>@since 3.17.0

---@class insx.kit.LSP.RelatedUnchangedDocumentDiagnosticReport : insx.kit.LSP.UnchangedDocumentDiagnosticReport
---@field public relatedDocuments? table<string, (insx.kit.LSP.FullDocumentDiagnosticReport | insx.kit.LSP.UnchangedDocumentDiagnosticReport)> Diagnostics of related documents. This information is useful<br>in programming languages where code in a file A can generate<br>diagnostics in a file B which A depends on. An example of<br>such a language is C/C++ where marco definitions in a file<br>a.cpp and result in errors in a header file b.hpp.<br><br>@since 3.17.0

---@class insx.kit.LSP.FullDocumentDiagnosticReport
---@field public kind "full" A full document diagnostic report.
---@field public resultId? string An optional result id. If provided it will<br>be sent on the next diagnostic request for the<br>same document.
---@field public items insx.kit.LSP.Diagnostic[] The actual items.

---@class insx.kit.LSP.UnchangedDocumentDiagnosticReport
---@field public kind "unchanged" A document diagnostic report indicating<br>no changes to the last result. A server can<br>only return `unchanged` if result ids are<br>provided.
---@field public resultId string A result id which will be sent on the next<br>diagnostic request for the same document.

---@class insx.kit.LSP.DiagnosticOptions : insx.kit.LSP.WorkDoneProgressOptions
---@field public identifier? string An optional identifier under which the diagnostics are<br>managed by the client.
---@field public interFileDependencies boolean Whether the language has inter file dependencies meaning that<br>editing code in one file can result in a different diagnostic<br>set in another file. Inter file dependencies are common for<br>most programming languages and typically uncommon for linters.
---@field public workspaceDiagnostics boolean The server provides support for workspace diagnostics as well.

---@class insx.kit.LSP.PreviousResultId
---@field public uri string The URI for which the client knowns a<br>result id.
---@field public value string The value of the previous result id.

---@class insx.kit.LSP.NotebookDocument
---@field public uri string The notebook document's uri.
---@field public notebookType string The type of the notebook.
---@field public version integer The version number of this document (it will increase after each<br>change, including undo/redo).
---@field public metadata? insx.kit.LSP.LSPObject Additional metadata stored with the notebook<br>document.<br><br>Note: should always be an object literal (e.g. LSPObject)
---@field public cells insx.kit.LSP.NotebookCell[] The cells of a notebook.

---@class insx.kit.LSP.TextDocumentItem
---@field public uri string The text document's uri.
---@field public languageId string The text document's language identifier.
---@field public version integer The version number of this document (it will increase after each<br>change, including undo/redo).
---@field public text string The content of the opened text document.

---@class insx.kit.LSP.VersionedNotebookDocumentIdentifier
---@field public version integer The version number of this notebook document.
---@field public uri string The notebook document's uri.

---@class insx.kit.LSP.NotebookDocumentChangeEvent
---@field public metadata? insx.kit.LSP.LSPObject The changed meta data if any.<br><br>Note: should always be an object literal (e.g. LSPObject)
---@field public cells? insx.kit.LSP.NotebookDocumentChangeEvent.cells Changes to cells

---@class insx.kit.LSP.NotebookDocumentChangeEvent.cells
---@field public structure? insx.kit.LSP.NotebookDocumentChangeEvent.cells.structure Changes to the cell structure to add or<br>remove cells.
---@field public data? insx.kit.LSP.NotebookCell[] Changes to notebook cells properties like its<br>kind, execution summary or metadata.
---@field public textContent? { document: insx.kit.LSP.VersionedTextDocumentIdentifier, changes: insx.kit.LSP.TextDocumentContentChangeEvent[] }[] Changes to the text content of notebook cells.

---@class insx.kit.LSP.NotebookDocumentChangeEvent.cells.structure
---@field public array insx.kit.LSP.NotebookCellArrayChange The change to the cell array.
---@field public didOpen? insx.kit.LSP.TextDocumentItem[] Additional opened cell text documents.
---@field public didClose? insx.kit.LSP.TextDocumentIdentifier[] Additional closed cell text documents.

---@class insx.kit.LSP.NotebookDocumentIdentifier
---@field public uri string The notebook document's uri.

---@class insx.kit.LSP.Registration
---@field public id string The id used to register the request. The id can be used to deregister<br>the request again.
---@field public method string The method / capability to register for.
---@field public registerOptions? insx.kit.LSP.LSPAny Options necessary for the registration.

---@class insx.kit.LSP.Unregistration
---@field public id string The id used to unregister the request or notification. Usually an id<br>provided during the register request.
---@field public method string The method to unregister for.

---@class insx.kit.LSP._InitializeParams : insx.kit.LSP.WorkDoneProgressParams
---@field public processId (integer | nil) The process Id of the parent process that started<br>the server.<br><br>Is `null` if the process has not been started by another process.<br>If the parent process is not alive then the server should exit.
---@field public clientInfo? insx.kit.LSP._InitializeParams.clientInfo Information about the client<br><br>@since 3.15.0
---@field public locale? string The locale the client is currently showing the user interface<br>in. This must not necessarily be the locale of the operating<br>system.<br><br>Uses IETF language tags as the value's syntax<br>(See https://en.wikipedia.org/wiki/IETF_language_tag)<br><br>@since 3.16.0
---@field public rootPath? (string | nil) The rootPath of the workspace. Is null<br>if no folder is open.<br><br>@deprecated in favour of rootUri.
---@field public rootUri (string | nil) The rootUri of the workspace. Is null if no<br>folder is open. If both `rootPath` and `rootUri` are set<br>`rootUri` wins.<br><br>@deprecated in favour of workspaceFolders.
---@field public capabilities insx.kit.LSP.ClientCapabilities The capabilities provided by the client (editor or tool)
---@field public initializationOptions? insx.kit.LSP.LSPAny User provided initialization options.
---@field public trace? ("off" | "messages" | "compact" | "verbose") The initial trace setting. If omitted trace is disabled ('off').

---@class insx.kit.LSP._InitializeParams.clientInfo
---@field public name string The name of the client as defined by the client.
---@field public version? string The client's version as defined by the client.

---@class insx.kit.LSP.WorkspaceFoldersInitializeParams
---@field public workspaceFolders? (insx.kit.LSP.WorkspaceFolder[] | nil) The workspace folders configured in the client when the server starts.<br><br>This property is only available if the client supports workspace folders.<br>It can be `null` if the client supports workspace folders but none are<br>configured.<br><br>@since 3.6.0

---@class insx.kit.LSP.ServerCapabilities
---@field public positionEncoding? insx.kit.LSP.PositionEncodingKind The position encoding the server picked from the encodings offered<br>by the client via the client capability `general.positionEncodings`.<br><br>If the client didn't provide any position encodings the only valid<br>value that a server can return is 'utf-16'.<br><br>If omitted it defaults to 'utf-16'.<br><br>@since 3.17.0
---@field public textDocumentSync? (insx.kit.LSP.TextDocumentSyncOptions | insx.kit.LSP.TextDocumentSyncKind) Defines how text documents are synced. Is either a detailed structure<br>defining each notification or for backwards compatibility the<br>TextDocumentSyncKind number.
---@field public notebookDocumentSync? (insx.kit.LSP.NotebookDocumentSyncOptions | insx.kit.LSP.NotebookDocumentSyncRegistrationOptions) Defines how notebook documents are synced.<br><br>@since 3.17.0
---@field public completionProvider? insx.kit.LSP.CompletionOptions The server provides completion support.
---@field public hoverProvider? (boolean | insx.kit.LSP.HoverOptions) The server provides hover support.
---@field public signatureHelpProvider? insx.kit.LSP.SignatureHelpOptions The server provides signature help support.
---@field public declarationProvider? (boolean | insx.kit.LSP.DeclarationOptions | insx.kit.LSP.DeclarationRegistrationOptions) The server provides Goto Declaration support.
---@field public definitionProvider? (boolean | insx.kit.LSP.DefinitionOptions) The server provides goto definition support.
---@field public typeDefinitionProvider? (boolean | insx.kit.LSP.TypeDefinitionOptions | insx.kit.LSP.TypeDefinitionRegistrationOptions) The server provides Goto Type Definition support.
---@field public implementationProvider? (boolean | insx.kit.LSP.ImplementationOptions | insx.kit.LSP.ImplementationRegistrationOptions) The server provides Goto Implementation support.
---@field public referencesProvider? (boolean | insx.kit.LSP.ReferenceOptions) The server provides find references support.
---@field public documentHighlightProvider? (boolean | insx.kit.LSP.DocumentHighlightOptions) The server provides document highlight support.
---@field public documentSymbolProvider? (boolean | insx.kit.LSP.DocumentSymbolOptions) The server provides document symbol support.
---@field public codeActionProvider? (boolean | insx.kit.LSP.CodeActionOptions) The server provides code actions. CodeActionOptions may only be<br>specified if the client states that it supports<br>`codeActionLiteralSupport` in its initial `initialize` request.
---@field public codeLensProvider? insx.kit.LSP.CodeLensOptions The server provides code lens.
---@field public documentLinkProvider? insx.kit.LSP.DocumentLinkOptions The server provides document link support.
---@field public colorProvider? (boolean | insx.kit.LSP.DocumentColorOptions | insx.kit.LSP.DocumentColorRegistrationOptions) The server provides color provider support.
---@field public workspaceSymbolProvider? (boolean | insx.kit.LSP.WorkspaceSymbolOptions) The server provides workspace symbol support.
---@field public documentFormattingProvider? (boolean | insx.kit.LSP.DocumentFormattingOptions) The server provides document formatting.
---@field public documentRangeFormattingProvider? (boolean | insx.kit.LSP.DocumentRangeFormattingOptions) The server provides document range formatting.
---@field public documentOnTypeFormattingProvider? insx.kit.LSP.DocumentOnTypeFormattingOptions The server provides document formatting on typing.
---@field public renameProvider? (boolean | insx.kit.LSP.RenameOptions) The server provides rename support. RenameOptions may only be<br>specified if the client states that it supports<br>`prepareSupport` in its initial `initialize` request.
---@field public foldingRangeProvider? (boolean | insx.kit.LSP.FoldingRangeOptions | insx.kit.LSP.FoldingRangeRegistrationOptions) The server provides folding provider support.
---@field public selectionRangeProvider? (boolean | insx.kit.LSP.SelectionRangeOptions | insx.kit.LSP.SelectionRangeRegistrationOptions) The server provides selection range support.
---@field public executeCommandProvider? insx.kit.LSP.ExecuteCommandOptions The server provides execute command support.
---@field public callHierarchyProvider? (boolean | insx.kit.LSP.CallHierarchyOptions | insx.kit.LSP.CallHierarchyRegistrationOptions) The server provides call hierarchy support.<br><br>@since 3.16.0
---@field public linkedEditingRangeProvider? (boolean | insx.kit.LSP.LinkedEditingRangeOptions | insx.kit.LSP.LinkedEditingRangeRegistrationOptions) The server provides linked editing range support.<br><br>@since 3.16.0
---@field public semanticTokensProvider? (insx.kit.LSP.SemanticTokensOptions | insx.kit.LSP.SemanticTokensRegistrationOptions) The server provides semantic tokens support.<br><br>@since 3.16.0
---@field public monikerProvider? (boolean | insx.kit.LSP.MonikerOptions | insx.kit.LSP.MonikerRegistrationOptions) The server provides moniker support.<br><br>@since 3.16.0
---@field public typeHierarchyProvider? (boolean | insx.kit.LSP.TypeHierarchyOptions | insx.kit.LSP.TypeHierarchyRegistrationOptions) The server provides type hierarchy support.<br><br>@since 3.17.0
---@field public inlineValueProvider? (boolean | insx.kit.LSP.InlineValueOptions | insx.kit.LSP.InlineValueRegistrationOptions) The server provides inline values.<br><br>@since 3.17.0
---@field public inlayHintProvider? (boolean | insx.kit.LSP.InlayHintOptions | insx.kit.LSP.InlayHintRegistrationOptions) The server provides inlay hints.<br><br>@since 3.17.0
---@field public diagnosticProvider? (insx.kit.LSP.DiagnosticOptions | insx.kit.LSP.DiagnosticRegistrationOptions) The server has support for pull model diagnostics.<br><br>@since 3.17.0
---@field public workspace? insx.kit.LSP.ServerCapabilities.workspace Workspace specific server capabilities.
---@field public experimental? insx.kit.LSP.LSPAny Experimental server capabilities.

---@class insx.kit.LSP.ServerCapabilities.workspace
---@field public workspaceFolders? insx.kit.LSP.WorkspaceFoldersServerCapabilities The server supports workspace folder.<br><br>@since 3.6.0
---@field public fileOperations? insx.kit.LSP.FileOperationOptions The server is interested in notifications/requests for operations on files.<br><br>@since 3.16.0

---@class insx.kit.LSP.VersionedTextDocumentIdentifier : insx.kit.LSP.TextDocumentIdentifier
---@field public version integer The version number of this document.

---@class insx.kit.LSP.SaveOptions
---@field public includeText? boolean The client is supposed to include the content on save.

---@class insx.kit.LSP.FileEvent
---@field public uri string The file's uri.
---@field public type insx.kit.LSP.FileChangeType The change type.

---@class insx.kit.LSP.FileSystemWatcher
---@field public globPattern insx.kit.LSP.GlobPattern The glob pattern to watch. See {@link GlobPattern glob pattern} for more detail.<br><br>@since 3.17.0 support for relative patterns.
---@field public kind? insx.kit.LSP.WatchKind The kind of events of interest. If omitted it defaults<br>to WatchKind.Create | WatchKind.Change | WatchKind.Delete<br>which is 7.

---@class insx.kit.LSP.Diagnostic
---@field public range insx.kit.LSP.Range The range at which the message applies
---@field public severity? insx.kit.LSP.DiagnosticSeverity The diagnostic's severity. Can be omitted. If omitted it is up to the<br>client to interpret diagnostics as error, warning, info or hint.
---@field public code? (integer | string) The diagnostic's code, which usually appear in the user interface.
---@field public codeDescription? insx.kit.LSP.CodeDescription An optional property to describe the error code.<br>Requires the code field (above) to be present/not null.<br><br>@since 3.16.0
---@field public source? string A human-readable string describing the source of this<br>diagnostic, e.g. 'typescript' or 'super lint'. It usually<br>appears in the user interface.
---@field public message string The diagnostic's message. It usually appears in the user interface
---@field public tags? insx.kit.LSP.DiagnosticTag[] Additional metadata about the diagnostic.<br><br>@since 3.15.0
---@field public relatedInformation? insx.kit.LSP.DiagnosticRelatedInformation[] An array of related diagnostic information, e.g. when symbol-names within<br>a scope collide all definitions can be marked via this property.
---@field public data? insx.kit.LSP.LSPAny A data entry field that is preserved between a `textDocument/publishDiagnostics`<br>notification and `textDocument/codeAction` request.<br><br>@since 3.16.0

---@class insx.kit.LSP.CompletionContext
---@field public triggerKind insx.kit.LSP.CompletionTriggerKind How the completion was triggered.
---@field public triggerCharacter? string The trigger character (a single character) that has trigger code complete.<br>Is undefined if `triggerKind !== CompletionTriggerKind.TriggerCharacter`

---@class insx.kit.LSP.CompletionItemLabelDetails
---@field public detail? string An optional string which is rendered less prominently directly after {@link CompletionItem.label label},<br>without any spacing. Should be used for function signatures and type annotations.
---@field public description? string An optional string which is rendered less prominently after {@link CompletionItem.detail}. Should be used<br>for fully qualified names and file paths.

---@class insx.kit.LSP.InsertReplaceEdit
---@field public newText string The string to be inserted.
---@field public insert insx.kit.LSP.Range The range if the insert is requested
---@field public replace insx.kit.LSP.Range The range if the replace is requested.

---@class insx.kit.LSP.CompletionOptions : insx.kit.LSP.WorkDoneProgressOptions
---@field public triggerCharacters? string[] Most tools trigger completion request automatically without explicitly requesting<br>it using a keyboard shortcut (e.g. Ctrl+Space). Typically they do so when the user<br>starts to type an identifier. For example if the user types `c` in a JavaScript file<br>code complete will automatically pop up present `console` besides others as a<br>completion item. Characters that make up identifiers don't need to be listed here.<br><br>If code complete should automatically be trigger on characters not being valid inside<br>an identifier (for example `.` in JavaScript) list them in `triggerCharacters`.
---@field public allCommitCharacters? string[] The list of all possible characters that commit a completion. This field can be used<br>if clients don't support individual commit characters per completion item. See<br>`ClientCapabilities.textDocument.completion.completionItem.commitCharactersSupport`<br><br>If a server provides both `allCommitCharacters` and commit characters on an individual<br>completion item the ones on the completion item win.<br><br>@since 3.2.0
---@field public resolveProvider? boolean The server provides support to resolve additional<br>information for a completion item.
---@field public completionItem? insx.kit.LSP.CompletionOptions.completionItem The server supports the following `CompletionItem` specific<br>capabilities.<br><br>@since 3.17.0

---@class insx.kit.LSP.CompletionOptions.completionItem
---@field public labelDetailsSupport? boolean The server has support for completion item label<br>details (see also `CompletionItemLabelDetails`) when<br>receiving a completion item in a resolve call.<br><br>@since 3.17.0

---@class insx.kit.LSP.HoverOptions : insx.kit.LSP.WorkDoneProgressOptions

---@class insx.kit.LSP.SignatureHelpContext
---@field public triggerKind insx.kit.LSP.SignatureHelpTriggerKind Action that caused signature help to be triggered.
---@field public triggerCharacter? string Character that caused signature help to be triggered.<br><br>This is undefined when `triggerKind !== SignatureHelpTriggerKind.TriggerCharacter`
---@field public isRetrigger boolean `true` if signature help was already showing when it was triggered.<br><br>Retriggers occurs when the signature help is already active and can be caused by actions such as<br>typing a trigger character, a cursor move, or document content changes.
---@field public activeSignatureHelp? insx.kit.LSP.SignatureHelp The currently active `SignatureHelp`.<br><br>The `activeSignatureHelp` has its `SignatureHelp.activeSignature` field updated based on<br>the user navigating through available signatures.

---@class insx.kit.LSP.SignatureInformation
---@field public label string The label of this signature. Will be shown in<br>the UI.
---@field public documentation? (string | insx.kit.LSP.MarkupContent) The human-readable doc-comment of this signature. Will be shown<br>in the UI but can be omitted.
---@field public parameters? insx.kit.LSP.ParameterInformation[] The parameters of this signature.
---@field public activeParameter? integer The index of the active parameter.<br><br>If provided, this is used in place of `SignatureHelp.activeParameter`.<br><br>@since 3.16.0

---@class insx.kit.LSP.SignatureHelpOptions : insx.kit.LSP.WorkDoneProgressOptions
---@field public triggerCharacters? string[] List of characters that trigger signature help automatically.
---@field public retriggerCharacters? string[] List of characters that re-trigger signature help.<br><br>These trigger characters are only active when signature help is already showing. All trigger characters<br>are also counted as re-trigger characters.<br><br>@since 3.15.0

---@class insx.kit.LSP.DefinitionOptions : insx.kit.LSP.WorkDoneProgressOptions

---@class insx.kit.LSP.ReferenceContext
---@field public includeDeclaration boolean Include the declaration of the current symbol.

---@class insx.kit.LSP.ReferenceOptions : insx.kit.LSP.WorkDoneProgressOptions

---@class insx.kit.LSP.DocumentHighlightOptions : insx.kit.LSP.WorkDoneProgressOptions

---@class insx.kit.LSP.BaseSymbolInformation
---@field public name string The name of this symbol.
---@field public kind insx.kit.LSP.SymbolKind The kind of this symbol.
---@field public tags? insx.kit.LSP.SymbolTag[] Tags for this symbol.<br><br>@since 3.16.0
---@field public containerName? string The name of the symbol containing this symbol. This information is for<br>user interface purposes (e.g. to render a qualifier in the user interface<br>if necessary). It can't be used to re-infer a hierarchy for the document<br>symbols.

---@class insx.kit.LSP.DocumentSymbolOptions : insx.kit.LSP.WorkDoneProgressOptions
---@field public label? string A human-readable string that is shown when multiple outlines trees<br>are shown for the same document.<br><br>@since 3.16.0

---@class insx.kit.LSP.CodeActionContext
---@field public diagnostics insx.kit.LSP.Diagnostic[] An array of diagnostics known on the client side overlapping the range provided to the<br>`textDocument/codeAction` request. They are provided so that the server knows which<br>errors are currently presented to the user for the given range. There is no guarantee<br>that these accurately reflect the error state of the resource. The primary parameter<br>to compute code actions is the provided range.
---@field public only? insx.kit.LSP.CodeActionKind[] Requested kind of actions to return.<br><br>Actions not of this kind are filtered out by the client before being shown. So servers<br>can omit computing them.
---@field public triggerKind? insx.kit.LSP.CodeActionTriggerKind The reason why code actions were requested.<br><br>@since 3.17.0

---@class insx.kit.LSP.CodeActionOptions : insx.kit.LSP.WorkDoneProgressOptions
---@field public codeActionKinds? insx.kit.LSP.CodeActionKind[] CodeActionKinds that this server may return.<br><br>The list of kinds may be generic, such as `CodeActionKind.Refactor`, or the server<br>may list out every specific kind they provide.
---@field public resolveProvider? boolean The server provides support to resolve additional<br>information for a code action.<br><br>@since 3.16.0

---@class insx.kit.LSP.WorkspaceSymbolOptions : insx.kit.LSP.WorkDoneProgressOptions
---@field public resolveProvider? boolean The server provides support to resolve additional<br>information for a workspace symbol.<br><br>@since 3.17.0

---@class insx.kit.LSP.CodeLensOptions : insx.kit.LSP.WorkDoneProgressOptions
---@field public resolveProvider? boolean Code lens has a resolve provider as well.

---@class insx.kit.LSP.DocumentLinkOptions : insx.kit.LSP.WorkDoneProgressOptions
---@field public resolveProvider? boolean Document links have a resolve provider as well.

---@class insx.kit.LSP.FormattingOptions
---@field public tabSize integer Size of a tab in spaces.
---@field public insertSpaces boolean Prefer spaces over tabs.
---@field public trimTrailingWhitespace? boolean Trim trailing whitespace on a line.<br><br>@since 3.15.0
---@field public insertFinalNewline? boolean Insert a newline character at the end of the file if one does not exist.<br><br>@since 3.15.0
---@field public trimFinalNewlines? boolean Trim all newlines after the final newline at the end of the file.<br><br>@since 3.15.0

---@class insx.kit.LSP.DocumentFormattingOptions : insx.kit.LSP.WorkDoneProgressOptions

---@class insx.kit.LSP.DocumentRangeFormattingOptions : insx.kit.LSP.WorkDoneProgressOptions

---@class insx.kit.LSP.DocumentOnTypeFormattingOptions
---@field public firstTriggerCharacter string A character on which formatting should be triggered, like `{`.
---@field public moreTriggerCharacter? string[] More trigger characters.

---@class insx.kit.LSP.RenameOptions : insx.kit.LSP.WorkDoneProgressOptions
---@field public prepareProvider? boolean Renames should be checked and tested before being executed.<br><br>@since version 3.12.0

---@class insx.kit.LSP.ExecuteCommandOptions : insx.kit.LSP.WorkDoneProgressOptions
---@field public commands string[] The commands to be executed on the server

---@class insx.kit.LSP.SemanticTokensLegend
---@field public tokenTypes string[] The token types a server uses.
---@field public tokenModifiers string[] The token modifiers a server uses.

---@class insx.kit.LSP.OptionalVersionedTextDocumentIdentifier : insx.kit.LSP.TextDocumentIdentifier
---@field public version (integer | nil) The version number of this document. If a versioned text document identifier<br>is sent from the server to the client and the file is not open in the editor<br>(the server has not received an open notification before) the server can send<br>`null` to indicate that the version is unknown and the content on disk is the<br>truth (as specified with document content ownership).

---@class insx.kit.LSP.AnnotatedTextEdit : insx.kit.LSP.TextEdit
---@field public annotationId insx.kit.LSP.ChangeAnnotationIdentifier The actual identifier of the change annotation

---@class insx.kit.LSP.ResourceOperation
---@field public kind string The resource operation kind.
---@field public annotationId? insx.kit.LSP.ChangeAnnotationIdentifier An optional annotation identifier describing the operation.<br><br>@since 3.16.0

---@class insx.kit.LSP.CreateFileOptions
---@field public overwrite? boolean Overwrite existing file. Overwrite wins over `ignoreIfExists`
---@field public ignoreIfExists? boolean Ignore if exists.

---@class insx.kit.LSP.RenameFileOptions
---@field public overwrite? boolean Overwrite target if existing. Overwrite wins over `ignoreIfExists`
---@field public ignoreIfExists? boolean Ignores if target exists.

---@class insx.kit.LSP.DeleteFileOptions
---@field public recursive? boolean Delete the content recursively if a folder is denoted.
---@field public ignoreIfNotExists? boolean Ignore the operation if the file doesn't exist.

---@class insx.kit.LSP.FileOperationPattern
---@field public glob string The glob pattern to match. Glob patterns can have the following syntax:<br>- `*` to match one or more characters in a path segment<br>- `?` to match on one character in a path segment<br>- `**` to match any number of path segments, including none<br>- `{}` to group sub patterns into an OR expression. (e.g. `**​/*.{ts,js}` matches all TypeScript and JavaScript files)<br>- `[]` to declare a range of characters to match in a path segment (e.g., `example.[0-9]` to match on `example.0`, `example.1`, …)<br>- `[!...]` to negate a range of characters to match in a path segment (e.g., `example.[!0-9]` to match on `example.a`, `example.b`, but not `example.0`)
---@field public matches? insx.kit.LSP.FileOperationPatternKind Whether to match files or folders with this pattern.<br><br>Matches both if undefined.
---@field public options? insx.kit.LSP.FileOperationPatternOptions Additional options used during matching.

---@class insx.kit.LSP.WorkspaceFullDocumentDiagnosticReport : insx.kit.LSP.FullDocumentDiagnosticReport
---@field public uri string The URI for which diagnostic information is reported.
---@field public version (integer | nil) The version number for which the diagnostics are reported.<br>If the document is not marked as open `null` can be provided.

---@class insx.kit.LSP.WorkspaceUnchangedDocumentDiagnosticReport : insx.kit.LSP.UnchangedDocumentDiagnosticReport
---@field public uri string The URI for which diagnostic information is reported.
---@field public version (integer | nil) The version number for which the diagnostics are reported.<br>If the document is not marked as open `null` can be provided.

---@class insx.kit.LSP.LSPObject

---@class insx.kit.LSP.NotebookCell
---@field public kind insx.kit.LSP.NotebookCellKind The cell's kind
---@field public document string The URI of the cell's text document<br>content.
---@field public metadata? insx.kit.LSP.LSPObject Additional metadata stored with the cell.<br><br>Note: should always be an object literal (e.g. LSPObject)
---@field public executionSummary? insx.kit.LSP.ExecutionSummary Additional execution summary information<br>if supported by the client.

---@class insx.kit.LSP.NotebookCellArrayChange
---@field public start integer The start oftest of the cell that changed.
---@field public deleteCount integer The deleted cells
---@field public cells? insx.kit.LSP.NotebookCell[] The new cells, if any

---@class insx.kit.LSP.ClientCapabilities
---@field public workspace? insx.kit.LSP.WorkspaceClientCapabilities Workspace specific client capabilities.
---@field public textDocument? insx.kit.LSP.TextDocumentClientCapabilities Text document specific client capabilities.
---@field public notebookDocument? insx.kit.LSP.NotebookDocumentClientCapabilities Capabilities specific to the notebook document support.<br><br>@since 3.17.0
---@field public window? insx.kit.LSP.WindowClientCapabilities Window specific client capabilities.
---@field public general? insx.kit.LSP.GeneralClientCapabilities General client capabilities.<br><br>@since 3.16.0
---@field public experimental? insx.kit.LSP.LSPAny Experimental client capabilities.

---@class insx.kit.LSP.TextDocumentSyncOptions
---@field public openClose? boolean Open and close notifications are sent to the server. If omitted open close notification should not<br>be sent.
---@field public change? insx.kit.LSP.TextDocumentSyncKind Change notifications are sent to the server. See TextDocumentSyncKind.None, TextDocumentSyncKind.Full<br>and TextDocumentSyncKind.Incremental. If omitted it defaults to TextDocumentSyncKind.None.
---@field public willSave? boolean If present will save notifications are sent to the server. If omitted the notification should not be<br>sent.
---@field public willSaveWaitUntil? boolean If present will save wait until requests are sent to the server. If omitted the request should not be<br>sent.
---@field public save? (boolean | insx.kit.LSP.SaveOptions) If present save notifications are sent to the server. If omitted the notification should not be<br>sent.

---@class insx.kit.LSP.NotebookDocumentSyncOptions
---@field public notebookSelector ({ notebook: (string | insx.kit.LSP.NotebookDocumentFilter), cells?: { language: string }[] } | { notebook?: (string | insx.kit.LSP.NotebookDocumentFilter), cells: { language: string }[] })[] The notebooks to be synced
---@field public save? boolean Whether save notification should be forwarded to<br>the server. Will only be honored if mode === `notebook`.

---@class insx.kit.LSP.NotebookDocumentSyncRegistrationOptions : insx.kit.LSP.NotebookDocumentSyncOptions, insx.kit.LSP.StaticRegistrationOptions

---@class insx.kit.LSP.WorkspaceFoldersServerCapabilities
---@field public supported? boolean The server has support for workspace folders
---@field public changeNotifications? (string | boolean) Whether the server wants to receive workspace folder<br>change notifications.<br><br>If a string is provided the string is treated as an ID<br>under which the notification is registered on the client<br>side. The ID can be used to unregister for these events<br>using the `client/unregisterCapability` request.

---@class insx.kit.LSP.FileOperationOptions
---@field public didCreate? insx.kit.LSP.FileOperationRegistrationOptions The server is interested in receiving didCreateFiles notifications.
---@field public willCreate? insx.kit.LSP.FileOperationRegistrationOptions The server is interested in receiving willCreateFiles requests.
---@field public didRename? insx.kit.LSP.FileOperationRegistrationOptions The server is interested in receiving didRenameFiles notifications.
---@field public willRename? insx.kit.LSP.FileOperationRegistrationOptions The server is interested in receiving willRenameFiles requests.
---@field public didDelete? insx.kit.LSP.FileOperationRegistrationOptions The server is interested in receiving didDeleteFiles file notifications.
---@field public willDelete? insx.kit.LSP.FileOperationRegistrationOptions The server is interested in receiving willDeleteFiles file requests.

---@class insx.kit.LSP.CodeDescription
---@field public href string An URI to open with more information about the diagnostic error.

---@class insx.kit.LSP.DiagnosticRelatedInformation
---@field public location insx.kit.LSP.Location The location of this related diagnostic information.
---@field public message string The message of this related diagnostic information.

---@class insx.kit.LSP.ParameterInformation
---@field public label (string | (integer | integer)[]) The label of this parameter information.<br><br>Either a string or an inclusive start and exclusive end offsets within its containing<br>signature label. (see SignatureInformation.label). The offsets are based on a UTF-16<br>string representation as `Position` and `Range` does.<br><br>*Note*: a label of type string should be a substring of its containing signature label.<br>Its intended use case is to highlight the parameter label part in the `SignatureInformation.label`.
---@field public documentation? (string | insx.kit.LSP.MarkupContent) The human-readable doc-comment of this parameter. Will be shown<br>in the UI but can be omitted.

---@class insx.kit.LSP.NotebookCellTextDocumentFilter
---@field public notebook (string | insx.kit.LSP.NotebookDocumentFilter) A filter that matches against the notebook<br>containing the notebook cell. If a string<br>value is provided it matches against the<br>notebook type. '*' matches every notebook.
---@field public language? string A language id like `python`.<br><br>Will be matched against the language id of the<br>notebook cell document. '*' matches every language.

---@class insx.kit.LSP.FileOperationPatternOptions
---@field public ignoreCase? boolean The pattern should be matched ignoring casing.

---@class insx.kit.LSP.ExecutionSummary
---@field public executionOrder integer A strict monotonically increasing value<br>indicating the execution order of a cell<br>inside a notebook.
---@field public success? boolean Whether the execution was successful or<br>not if known by the client.

---@class insx.kit.LSP.WorkspaceClientCapabilities
---@field public applyEdit? boolean The client supports applying batch edits<br>to the workspace by supporting the request<br>'workspace/applyEdit'
---@field public workspaceEdit? insx.kit.LSP.WorkspaceEditClientCapabilities Capabilities specific to `WorkspaceEdit`s.
---@field public didChangeConfiguration? insx.kit.LSP.DidChangeConfigurationClientCapabilities Capabilities specific to the `workspace/didChangeConfiguration` notification.
---@field public didChangeWatchedFiles? insx.kit.LSP.DidChangeWatchedFilesClientCapabilities Capabilities specific to the `workspace/didChangeWatchedFiles` notification.
---@field public symbol? insx.kit.LSP.WorkspaceSymbolClientCapabilities Capabilities specific to the `workspace/symbol` request.
---@field public executeCommand? insx.kit.LSP.ExecuteCommandClientCapabilities Capabilities specific to the `workspace/executeCommand` request.
---@field public workspaceFolders? boolean The client has support for workspace folders.<br><br>@since 3.6.0
---@field public configuration? boolean The client supports `workspace/configuration` requests.<br><br>@since 3.6.0
---@field public semanticTokens? insx.kit.LSP.SemanticTokensWorkspaceClientCapabilities Capabilities specific to the semantic token requests scoped to the<br>workspace.<br><br>@since 3.16.0.
---@field public codeLens? insx.kit.LSP.CodeLensWorkspaceClientCapabilities Capabilities specific to the code lens requests scoped to the<br>workspace.<br><br>@since 3.16.0.
---@field public fileOperations? insx.kit.LSP.FileOperationClientCapabilities The client has support for file notifications/requests for user operations on files.<br><br>Since 3.16.0
---@field public inlineValue? insx.kit.LSP.InlineValueWorkspaceClientCapabilities Capabilities specific to the inline values requests scoped to the<br>workspace.<br><br>@since 3.17.0.
---@field public inlayHint? insx.kit.LSP.InlayHintWorkspaceClientCapabilities Capabilities specific to the inlay hint requests scoped to the<br>workspace.<br><br>@since 3.17.0.
---@field public diagnostics? insx.kit.LSP.DiagnosticWorkspaceClientCapabilities Capabilities specific to the diagnostic requests scoped to the<br>workspace.<br><br>@since 3.17.0.

---@class insx.kit.LSP.TextDocumentClientCapabilities
---@field public synchronization? insx.kit.LSP.TextDocumentSyncClientCapabilities Defines which synchronization capabilities the client supports.
---@field public completion? insx.kit.LSP.CompletionClientCapabilities Capabilities specific to the `textDocument/completion` request.
---@field public hover? insx.kit.LSP.HoverClientCapabilities Capabilities specific to the `textDocument/hover` request.
---@field public signatureHelp? insx.kit.LSP.SignatureHelpClientCapabilities Capabilities specific to the `textDocument/signatureHelp` request.
---@field public declaration? insx.kit.LSP.DeclarationClientCapabilities Capabilities specific to the `textDocument/declaration` request.<br><br>@since 3.14.0
---@field public definition? insx.kit.LSP.DefinitionClientCapabilities Capabilities specific to the `textDocument/definition` request.
---@field public typeDefinition? insx.kit.LSP.TypeDefinitionClientCapabilities Capabilities specific to the `textDocument/typeDefinition` request.<br><br>@since 3.6.0
---@field public implementation? insx.kit.LSP.ImplementationClientCapabilities Capabilities specific to the `textDocument/implementation` request.<br><br>@since 3.6.0
---@field public references? insx.kit.LSP.ReferenceClientCapabilities Capabilities specific to the `textDocument/references` request.
---@field public documentHighlight? insx.kit.LSP.DocumentHighlightClientCapabilities Capabilities specific to the `textDocument/documentHighlight` request.
---@field public documentSymbol? insx.kit.LSP.DocumentSymbolClientCapabilities Capabilities specific to the `textDocument/documentSymbol` request.
---@field public codeAction? insx.kit.LSP.CodeActionClientCapabilities Capabilities specific to the `textDocument/codeAction` request.
---@field public codeLens? insx.kit.LSP.CodeLensClientCapabilities Capabilities specific to the `textDocument/codeLens` request.
---@field public documentLink? insx.kit.LSP.DocumentLinkClientCapabilities Capabilities specific to the `textDocument/documentLink` request.
---@field public colorProvider? insx.kit.LSP.DocumentColorClientCapabilities Capabilities specific to the `textDocument/documentColor` and the<br>`textDocument/colorPresentation` request.<br><br>@since 3.6.0
---@field public formatting? insx.kit.LSP.DocumentFormattingClientCapabilities Capabilities specific to the `textDocument/formatting` request.
---@field public rangeFormatting? insx.kit.LSP.DocumentRangeFormattingClientCapabilities Capabilities specific to the `textDocument/rangeFormatting` request.
---@field public onTypeFormatting? insx.kit.LSP.DocumentOnTypeFormattingClientCapabilities Capabilities specific to the `textDocument/onTypeFormatting` request.
---@field public rename? insx.kit.LSP.RenameClientCapabilities Capabilities specific to the `textDocument/rename` request.
---@field public foldingRange? insx.kit.LSP.FoldingRangeClientCapabilities Capabilities specific to the `textDocument/foldingRange` request.<br><br>@since 3.10.0
---@field public selectionRange? insx.kit.LSP.SelectionRangeClientCapabilities Capabilities specific to the `textDocument/selectionRange` request.<br><br>@since 3.15.0
---@field public publishDiagnostics? insx.kit.LSP.PublishDiagnosticsClientCapabilities Capabilities specific to the `textDocument/publishDiagnostics` notification.
---@field public callHierarchy? insx.kit.LSP.CallHierarchyClientCapabilities Capabilities specific to the various call hierarchy requests.<br><br>@since 3.16.0
---@field public semanticTokens? insx.kit.LSP.SemanticTokensClientCapabilities Capabilities specific to the various semantic token request.<br><br>@since 3.16.0
---@field public linkedEditingRange? insx.kit.LSP.LinkedEditingRangeClientCapabilities Capabilities specific to the `textDocument/linkedEditingRange` request.<br><br>@since 3.16.0
---@field public moniker? insx.kit.LSP.MonikerClientCapabilities Client capabilities specific to the `textDocument/moniker` request.<br><br>@since 3.16.0
---@field public typeHierarchy? insx.kit.LSP.TypeHierarchyClientCapabilities Capabilities specific to the various type hierarchy requests.<br><br>@since 3.17.0
---@field public inlineValue? insx.kit.LSP.InlineValueClientCapabilities Capabilities specific to the `textDocument/inlineValue` request.<br><br>@since 3.17.0
---@field public inlayHint? insx.kit.LSP.InlayHintClientCapabilities Capabilities specific to the `textDocument/inlayHint` request.<br><br>@since 3.17.0
---@field public diagnostic? insx.kit.LSP.DiagnosticClientCapabilities Capabilities specific to the diagnostic pull model.<br><br>@since 3.17.0

---@class insx.kit.LSP.NotebookDocumentClientCapabilities
---@field public synchronization insx.kit.LSP.NotebookDocumentSyncClientCapabilities Capabilities specific to notebook document synchronization<br><br>@since 3.17.0

---@class insx.kit.LSP.WindowClientCapabilities
---@field public workDoneProgress? boolean It indicates whether the client supports server initiated<br>progress using the `window/workDoneProgress/create` request.<br><br>The capability also controls Whether client supports handling<br>of progress notifications. If set servers are allowed to report a<br>`workDoneProgress` property in the request specific server<br>capabilities.<br><br>@since 3.15.0
---@field public showMessage? insx.kit.LSP.ShowMessageRequestClientCapabilities Capabilities specific to the showMessage request.<br><br>@since 3.16.0
---@field public showDocument? insx.kit.LSP.ShowDocumentClientCapabilities Capabilities specific to the showDocument request.<br><br>@since 3.16.0

---@class insx.kit.LSP.GeneralClientCapabilities
---@field public staleRequestSupport? insx.kit.LSP.GeneralClientCapabilities.staleRequestSupport Client capability that signals how the client<br>handles stale requests (e.g. a request<br>for which the client will not process the response<br>anymore since the information is outdated).<br><br>@since 3.17.0
---@field public regularExpressions? insx.kit.LSP.RegularExpressionsClientCapabilities Client capabilities specific to regular expressions.<br><br>@since 3.16.0
---@field public markdown? insx.kit.LSP.MarkdownClientCapabilities Client capabilities specific to the client's markdown parser.<br><br>@since 3.16.0
---@field public positionEncodings? insx.kit.LSP.PositionEncodingKind[] The position encodings supported by the client. Client and server<br>have to agree on the same position encoding to ensure that offsets<br>(e.g. character position in a line) are interpreted the same on both<br>sides.<br><br>To keep the protocol backwards compatible the following applies: if<br>the value 'utf-16' is missing from the array of position encodings<br>servers can assume that the client supports UTF-16. UTF-16 is<br>therefore a mandatory encoding.<br><br>If omitted it defaults to ['utf-16'].<br><br>Implementation considerations: since the conversion from one encoding<br>into another requires the content of the file / line the conversion<br>is best done where the file is read which is usually on the server<br>side.<br><br>@since 3.17.0

---@class insx.kit.LSP.GeneralClientCapabilities.staleRequestSupport
---@field public cancel boolean The client will actively cancel the request.
---@field public retryOnContentModified string[] The list of requests for which the client<br>will retry the request if it receives a<br>response with error code `ContentModified`

---@class insx.kit.LSP.RelativePattern
---@field public baseUri (insx.kit.LSP.WorkspaceFolder | string) A workspace folder or a base URI to which this pattern will be matched<br>against relatively.
---@field public pattern insx.kit.LSP.Pattern The actual glob pattern;

---@class insx.kit.LSP.WorkspaceEditClientCapabilities
---@field public documentChanges? boolean The client supports versioned document changes in `WorkspaceEdit`s
---@field public resourceOperations? insx.kit.LSP.ResourceOperationKind[] The resource operations the client supports. Clients should at least<br>support 'create', 'rename' and 'delete' files and folders.<br><br>@since 3.13.0
---@field public failureHandling? insx.kit.LSP.FailureHandlingKind The failure handling strategy of a client if applying the workspace edit<br>fails.<br><br>@since 3.13.0
---@field public normalizesLineEndings? boolean Whether the client normalizes line endings to the client specific<br>setting.<br>If set to `true` the client will normalize line ending characters<br>in a workspace edit to the client-specified new line<br>character.<br><br>@since 3.16.0
---@field public changeAnnotationSupport? insx.kit.LSP.WorkspaceEditClientCapabilities.changeAnnotationSupport Whether the client in general supports change annotations on text edits,<br>create file, rename file and delete file changes.<br><br>@since 3.16.0

---@class insx.kit.LSP.WorkspaceEditClientCapabilities.changeAnnotationSupport
---@field public groupsOnLabel? boolean Whether the client groups edits with equal labels into tree nodes,<br>for instance all edits labelled with "Changes in Strings" would<br>be a tree node.

---@class insx.kit.LSP.DidChangeConfigurationClientCapabilities
---@field public dynamicRegistration? boolean Did change configuration notification supports dynamic registration.

---@class insx.kit.LSP.DidChangeWatchedFilesClientCapabilities
---@field public dynamicRegistration? boolean Did change watched files notification supports dynamic registration. Please note<br>that the current protocol doesn't support static configuration for file changes<br>from the server side.
---@field public relativePatternSupport? boolean Whether the client has support for {@link  RelativePattern relative pattern}<br>or not.<br><br>@since 3.17.0

---@class insx.kit.LSP.WorkspaceSymbolClientCapabilities
---@field public dynamicRegistration? boolean Symbol request supports dynamic registration.
---@field public symbolKind? insx.kit.LSP.WorkspaceSymbolClientCapabilities.symbolKind Specific capabilities for the `SymbolKind` in the `workspace/symbol` request.
---@field public tagSupport? insx.kit.LSP.WorkspaceSymbolClientCapabilities.tagSupport The client supports tags on `SymbolInformation`.<br>Clients supporting tags have to handle unknown tags gracefully.<br><br>@since 3.16.0
---@field public resolveSupport? insx.kit.LSP.WorkspaceSymbolClientCapabilities.resolveSupport The client support partial workspace symbols. The client will send the<br>request `workspaceSymbol/resolve` to the server to resolve additional<br>properties.<br><br>@since 3.17.0

---@class insx.kit.LSP.WorkspaceSymbolClientCapabilities.symbolKind
---@field public valueSet? insx.kit.LSP.SymbolKind[] The symbol kind values the client supports. When this<br>property exists the client also guarantees that it will<br>handle values outside its set gracefully and falls back<br>to a default value when unknown.<br><br>If this property is not present the client only supports<br>the symbol kinds from `File` to `Array` as defined in<br>the initial version of the protocol.

---@class insx.kit.LSP.WorkspaceSymbolClientCapabilities.tagSupport
---@field public valueSet insx.kit.LSP.SymbolTag[] The tags supported by the client.

---@class insx.kit.LSP.WorkspaceSymbolClientCapabilities.resolveSupport
---@field public properties string[] The properties that a client can resolve lazily. Usually<br>`location.range`

---@class insx.kit.LSP.ExecuteCommandClientCapabilities
---@field public dynamicRegistration? boolean Execute command supports dynamic registration.

---@class insx.kit.LSP.SemanticTokensWorkspaceClientCapabilities
---@field public refreshSupport? boolean Whether the client implementation supports a refresh request sent from<br>the server to the client.<br><br>Note that this event is global and will force the client to refresh all<br>semantic tokens currently shown. It should be used with absolute care<br>and is useful for situation where a server for example detects a project<br>wide change that requires such a calculation.

---@class insx.kit.LSP.CodeLensWorkspaceClientCapabilities
---@field public refreshSupport? boolean Whether the client implementation supports a refresh request sent from the<br>server to the client.<br><br>Note that this event is global and will force the client to refresh all<br>code lenses currently shown. It should be used with absolute care and is<br>useful for situation where a server for example detect a project wide<br>change that requires such a calculation.

---@class insx.kit.LSP.FileOperationClientCapabilities
---@field public dynamicRegistration? boolean Whether the client supports dynamic registration for file requests/notifications.
---@field public didCreate? boolean The client has support for sending didCreateFiles notifications.
---@field public willCreate? boolean The client has support for sending willCreateFiles requests.
---@field public didRename? boolean The client has support for sending didRenameFiles notifications.
---@field public willRename? boolean The client has support for sending willRenameFiles requests.
---@field public didDelete? boolean The client has support for sending didDeleteFiles notifications.
---@field public willDelete? boolean The client has support for sending willDeleteFiles requests.

---@class insx.kit.LSP.InlineValueWorkspaceClientCapabilities
---@field public refreshSupport? boolean Whether the client implementation supports a refresh request sent from the<br>server to the client.<br><br>Note that this event is global and will force the client to refresh all<br>inline values currently shown. It should be used with absolute care and is<br>useful for situation where a server for example detects a project wide<br>change that requires such a calculation.

---@class insx.kit.LSP.InlayHintWorkspaceClientCapabilities
---@field public refreshSupport? boolean Whether the client implementation supports a refresh request sent from<br>the server to the client.<br><br>Note that this event is global and will force the client to refresh all<br>inlay hints currently shown. It should be used with absolute care and<br>is useful for situation where a server for example detects a project wide<br>change that requires such a calculation.

---@class insx.kit.LSP.DiagnosticWorkspaceClientCapabilities
---@field public refreshSupport? boolean Whether the client implementation supports a refresh request sent from<br>the server to the client.<br><br>Note that this event is global and will force the client to refresh all<br>pulled diagnostics currently shown. It should be used with absolute care and<br>is useful for situation where a server for example detects a project wide<br>change that requires such a calculation.

---@class insx.kit.LSP.TextDocumentSyncClientCapabilities
---@field public dynamicRegistration? boolean Whether text document synchronization supports dynamic registration.
---@field public willSave? boolean The client supports sending will save notifications.
---@field public willSaveWaitUntil? boolean The client supports sending a will save request and<br>waits for a response providing text edits which will<br>be applied to the document before it is saved.
---@field public didSave? boolean The client supports did save notifications.

---@class insx.kit.LSP.CompletionClientCapabilities
---@field public dynamicRegistration? boolean Whether completion supports dynamic registration.
---@field public completionItem? insx.kit.LSP.CompletionClientCapabilities.completionItem The client supports the following `CompletionItem` specific<br>capabilities.
---@field public completionItemKind? insx.kit.LSP.CompletionClientCapabilities.completionItemKind
---@field public insertTextMode? insx.kit.LSP.InsertTextMode Defines how the client handles whitespace and indentation<br>when accepting a completion item that uses multi line<br>text in either `insertText` or `textEdit`.<br><br>@since 3.17.0
---@field public contextSupport? boolean The client supports to send additional context information for a<br>`textDocument/completion` request.
---@field public completionList? insx.kit.LSP.CompletionClientCapabilities.completionList The client supports the following `CompletionList` specific<br>capabilities.<br><br>@since 3.17.0

---@class insx.kit.LSP.CompletionClientCapabilities.completionItem
---@field public snippetSupport? boolean Client supports snippets as insert text.<br><br>A snippet can define tab stops and placeholders with `$1`, `$2`<br>and `${3:foo}`. `$0` defines the final tab stop, it defaults to<br>the end of the snippet. Placeholders with equal identifiers are linked,<br>that is typing in one will update others too.
---@field public commitCharactersSupport? boolean Client supports commit characters on a completion item.
---@field public documentationFormat? insx.kit.LSP.MarkupKind[] Client supports the following content formats for the documentation<br>property. The order describes the preferred format of the client.
---@field public deprecatedSupport? boolean Client supports the deprecated property on a completion item.
---@field public preselectSupport? boolean Client supports the preselect property on a completion item.
---@field public tagSupport? insx.kit.LSP.CompletionClientCapabilities.completionItem.tagSupport Client supports the tag property on a completion item. Clients supporting<br>tags have to handle unknown tags gracefully. Clients especially need to<br>preserve unknown tags when sending a completion item back to the server in<br>a resolve call.<br><br>@since 3.15.0
---@field public insertReplaceSupport? boolean Client support insert replace edit to control different behavior if a<br>completion item is inserted in the text or should replace text.<br><br>@since 3.16.0
---@field public resolveSupport? insx.kit.LSP.CompletionClientCapabilities.completionItem.resolveSupport Indicates which properties a client can resolve lazily on a completion<br>item. Before version 3.16.0 only the predefined properties `documentation`<br>and `details` could be resolved lazily.<br><br>@since 3.16.0
---@field public insertTextModeSupport? insx.kit.LSP.CompletionClientCapabilities.completionItem.insertTextModeSupport The client supports the `insertTextMode` property on<br>a completion item to override the whitespace handling mode<br>as defined by the client (see `insertTextMode`).<br><br>@since 3.16.0
---@field public labelDetailsSupport? boolean The client has support for completion item label<br>details (see also `CompletionItemLabelDetails`).<br><br>@since 3.17.0

---@class insx.kit.LSP.CompletionClientCapabilities.completionItem.tagSupport
---@field public valueSet insx.kit.LSP.CompletionItemTag[] The tags supported by the client.

---@class insx.kit.LSP.CompletionClientCapabilities.completionItem.resolveSupport
---@field public properties string[] The properties that a client can resolve lazily.

---@class insx.kit.LSP.CompletionClientCapabilities.completionItem.insertTextModeSupport
---@field public valueSet insx.kit.LSP.InsertTextMode[]

---@class insx.kit.LSP.CompletionClientCapabilities.completionItemKind
---@field public valueSet? insx.kit.LSP.CompletionItemKind[] The completion item kind values the client supports. When this<br>property exists the client also guarantees that it will<br>handle values outside its set gracefully and falls back<br>to a default value when unknown.<br><br>If this property is not present the client only supports<br>the completion items kinds from `Text` to `Reference` as defined in<br>the initial version of the protocol.

---@class insx.kit.LSP.CompletionClientCapabilities.completionList
---@field public itemDefaults? string[] The client supports the following itemDefaults on<br>a completion list.<br><br>The value lists the supported property names of the<br>`CompletionList.itemDefaults` object. If omitted<br>no properties are supported.<br><br>@since 3.17.0

---@class insx.kit.LSP.HoverClientCapabilities
---@field public dynamicRegistration? boolean Whether hover supports dynamic registration.
---@field public contentFormat? insx.kit.LSP.MarkupKind[] Client supports the following content formats for the content<br>property. The order describes the preferred format of the client.

---@class insx.kit.LSP.SignatureHelpClientCapabilities
---@field public dynamicRegistration? boolean Whether signature help supports dynamic registration.
---@field public signatureInformation? insx.kit.LSP.SignatureHelpClientCapabilities.signatureInformation The client supports the following `SignatureInformation`<br>specific properties.
---@field public contextSupport? boolean The client supports to send additional context information for a<br>`textDocument/signatureHelp` request. A client that opts into<br>contextSupport will also support the `retriggerCharacters` on<br>`SignatureHelpOptions`.<br><br>@since 3.15.0

---@class insx.kit.LSP.SignatureHelpClientCapabilities.signatureInformation
---@field public documentationFormat? insx.kit.LSP.MarkupKind[] Client supports the following content formats for the documentation<br>property. The order describes the preferred format of the client.
---@field public parameterInformation? insx.kit.LSP.SignatureHelpClientCapabilities.signatureInformation.parameterInformation Client capabilities specific to parameter information.
---@field public activeParameterSupport? boolean The client supports the `activeParameter` property on `SignatureInformation`<br>literal.<br><br>@since 3.16.0

---@class insx.kit.LSP.SignatureHelpClientCapabilities.signatureInformation.parameterInformation
---@field public labelOffsetSupport? boolean The client supports processing label offsets instead of a<br>simple label string.<br><br>@since 3.14.0

---@class insx.kit.LSP.DeclarationClientCapabilities
---@field public dynamicRegistration? boolean Whether declaration supports dynamic registration. If this is set to `true`<br>the client supports the new `DeclarationRegistrationOptions` return value<br>for the corresponding server capability as well.
---@field public linkSupport? boolean The client supports additional metadata in the form of declaration links.

---@class insx.kit.LSP.DefinitionClientCapabilities
---@field public dynamicRegistration? boolean Whether definition supports dynamic registration.
---@field public linkSupport? boolean The client supports additional metadata in the form of definition links.<br><br>@since 3.14.0

---@class insx.kit.LSP.TypeDefinitionClientCapabilities
---@field public dynamicRegistration? boolean Whether implementation supports dynamic registration. If this is set to `true`<br>the client supports the new `TypeDefinitionRegistrationOptions` return value<br>for the corresponding server capability as well.
---@field public linkSupport? boolean The client supports additional metadata in the form of definition links.<br><br>Since 3.14.0

---@class insx.kit.LSP.ImplementationClientCapabilities
---@field public dynamicRegistration? boolean Whether implementation supports dynamic registration. If this is set to `true`<br>the client supports the new `ImplementationRegistrationOptions` return value<br>for the corresponding server capability as well.
---@field public linkSupport? boolean The client supports additional metadata in the form of definition links.<br><br>@since 3.14.0

---@class insx.kit.LSP.ReferenceClientCapabilities
---@field public dynamicRegistration? boolean Whether references supports dynamic registration.

---@class insx.kit.LSP.DocumentHighlightClientCapabilities
---@field public dynamicRegistration? boolean Whether document highlight supports dynamic registration.

---@class insx.kit.LSP.DocumentSymbolClientCapabilities
---@field public dynamicRegistration? boolean Whether document symbol supports dynamic registration.
---@field public symbolKind? insx.kit.LSP.DocumentSymbolClientCapabilities.symbolKind Specific capabilities for the `SymbolKind` in the<br>`textDocument/documentSymbol` request.
---@field public hierarchicalDocumentSymbolSupport? boolean The client supports hierarchical document symbols.
---@field public tagSupport? insx.kit.LSP.DocumentSymbolClientCapabilities.tagSupport The client supports tags on `SymbolInformation`. Tags are supported on<br>`DocumentSymbol` if `hierarchicalDocumentSymbolSupport` is set to true.<br>Clients supporting tags have to handle unknown tags gracefully.<br><br>@since 3.16.0
---@field public labelSupport? boolean The client supports an additional label presented in the UI when<br>registering a document symbol provider.<br><br>@since 3.16.0

---@class insx.kit.LSP.DocumentSymbolClientCapabilities.symbolKind
---@field public valueSet? insx.kit.LSP.SymbolKind[] The symbol kind values the client supports. When this<br>property exists the client also guarantees that it will<br>handle values outside its set gracefully and falls back<br>to a default value when unknown.<br><br>If this property is not present the client only supports<br>the symbol kinds from `File` to `Array` as defined in<br>the initial version of the protocol.

---@class insx.kit.LSP.DocumentSymbolClientCapabilities.tagSupport
---@field public valueSet insx.kit.LSP.SymbolTag[] The tags supported by the client.

---@class insx.kit.LSP.CodeActionClientCapabilities
---@field public dynamicRegistration? boolean Whether code action supports dynamic registration.
---@field public codeActionLiteralSupport? insx.kit.LSP.CodeActionClientCapabilities.codeActionLiteralSupport The client support code action literals of type `CodeAction` as a valid<br>response of the `textDocument/codeAction` request. If the property is not<br>set the request can only return `Command` literals.<br><br>@since 3.8.0
---@field public isPreferredSupport? boolean Whether code action supports the `isPreferred` property.<br><br>@since 3.15.0
---@field public disabledSupport? boolean Whether code action supports the `disabled` property.<br><br>@since 3.16.0
---@field public dataSupport? boolean Whether code action supports the `data` property which is<br>preserved between a `textDocument/codeAction` and a<br>`codeAction/resolve` request.<br><br>@since 3.16.0
---@field public resolveSupport? insx.kit.LSP.CodeActionClientCapabilities.resolveSupport Whether the client supports resolving additional code action<br>properties via a separate `codeAction/resolve` request.<br><br>@since 3.16.0
---@field public honorsChangeAnnotations? boolean Whether the client honors the change annotations in<br>text edits and resource operations returned via the<br>`CodeAction#edit` property by for example presenting<br>the workspace edit in the user interface and asking<br>for confirmation.<br><br>@since 3.16.0

---@class insx.kit.LSP.CodeActionClientCapabilities.codeActionLiteralSupport
---@field public codeActionKind insx.kit.LSP.CodeActionClientCapabilities.codeActionLiteralSupport.codeActionKind The code action kind is support with the following value<br>set.

---@class insx.kit.LSP.CodeActionClientCapabilities.codeActionLiteralSupport.codeActionKind
---@field public valueSet insx.kit.LSP.CodeActionKind[] The code action kind values the client supports. When this<br>property exists the client also guarantees that it will<br>handle values outside its set gracefully and falls back<br>to a default value when unknown.

---@class insx.kit.LSP.CodeActionClientCapabilities.resolveSupport
---@field public properties string[] The properties that a client can resolve lazily.

---@class insx.kit.LSP.CodeLensClientCapabilities
---@field public dynamicRegistration? boolean Whether code lens supports dynamic registration.

---@class insx.kit.LSP.DocumentLinkClientCapabilities
---@field public dynamicRegistration? boolean Whether document link supports dynamic registration.
---@field public tooltipSupport? boolean Whether the client supports the `tooltip` property on `DocumentLink`.<br><br>@since 3.15.0

---@class insx.kit.LSP.DocumentColorClientCapabilities
---@field public dynamicRegistration? boolean Whether implementation supports dynamic registration. If this is set to `true`<br>the client supports the new `DocumentColorRegistrationOptions` return value<br>for the corresponding server capability as well.

---@class insx.kit.LSP.DocumentFormattingClientCapabilities
---@field public dynamicRegistration? boolean Whether formatting supports dynamic registration.

---@class insx.kit.LSP.DocumentRangeFormattingClientCapabilities
---@field public dynamicRegistration? boolean Whether range formatting supports dynamic registration.

---@class insx.kit.LSP.DocumentOnTypeFormattingClientCapabilities
---@field public dynamicRegistration? boolean Whether on type formatting supports dynamic registration.

---@class insx.kit.LSP.RenameClientCapabilities
---@field public dynamicRegistration? boolean Whether rename supports dynamic registration.
---@field public prepareSupport? boolean Client supports testing for validity of rename operations<br>before execution.<br><br>@since 3.12.0
---@field public prepareSupportDefaultBehavior? insx.kit.LSP.PrepareSupportDefaultBehavior Client supports the default behavior result.<br><br>The value indicates the default behavior used by the<br>client.<br><br>@since 3.16.0
---@field public honorsChangeAnnotations? boolean Whether the client honors the change annotations in<br>text edits and resource operations returned via the<br>rename request's workspace edit by for example presenting<br>the workspace edit in the user interface and asking<br>for confirmation.<br><br>@since 3.16.0

---@class insx.kit.LSP.FoldingRangeClientCapabilities
---@field public dynamicRegistration? boolean Whether implementation supports dynamic registration for folding range<br>providers. If this is set to `true` the client supports the new<br>`FoldingRangeRegistrationOptions` return value for the corresponding<br>server capability as well.
---@field public rangeLimit? integer The maximum number of folding ranges that the client prefers to receive<br>per document. The value serves as a hint, servers are free to follow the<br>limit.
---@field public lineFoldingOnly? boolean If set, the client signals that it only supports folding complete lines.<br>If set, client will ignore specified `startCharacter` and `endCharacter`<br>properties in a FoldingRange.
---@field public foldingRangeKind? insx.kit.LSP.FoldingRangeClientCapabilities.foldingRangeKind Specific options for the folding range kind.<br><br>@since 3.17.0
---@field public foldingRange? insx.kit.LSP.FoldingRangeClientCapabilities.foldingRange Specific options for the folding range.<br><br>@since 3.17.0

---@class insx.kit.LSP.FoldingRangeClientCapabilities.foldingRangeKind
---@field public valueSet? insx.kit.LSP.FoldingRangeKind[] The folding range kind values the client supports. When this<br>property exists the client also guarantees that it will<br>handle values outside its set gracefully and falls back<br>to a default value when unknown.

---@class insx.kit.LSP.FoldingRangeClientCapabilities.foldingRange
---@field public collapsedText? boolean If set, the client signals that it supports setting collapsedText on<br>folding ranges to display custom labels instead of the default text.<br><br>@since 3.17.0

---@class insx.kit.LSP.SelectionRangeClientCapabilities
---@field public dynamicRegistration? boolean Whether implementation supports dynamic registration for selection range providers. If this is set to `true`<br>the client supports the new `SelectionRangeRegistrationOptions` return value for the corresponding server<br>capability as well.

---@class insx.kit.LSP.PublishDiagnosticsClientCapabilities
---@field public relatedInformation? boolean Whether the clients accepts diagnostics with related information.
---@field public tagSupport? insx.kit.LSP.PublishDiagnosticsClientCapabilities.tagSupport Client supports the tag property to provide meta data about a diagnostic.<br>Clients supporting tags have to handle unknown tags gracefully.<br><br>@since 3.15.0
---@field public versionSupport? boolean Whether the client interprets the version property of the<br>`textDocument/publishDiagnostics` notification's parameter.<br><br>@since 3.15.0
---@field public codeDescriptionSupport? boolean Client supports a codeDescription property<br><br>@since 3.16.0
---@field public dataSupport? boolean Whether code action supports the `data` property which is<br>preserved between a `textDocument/publishDiagnostics` and<br>`textDocument/codeAction` request.<br><br>@since 3.16.0

---@class insx.kit.LSP.PublishDiagnosticsClientCapabilities.tagSupport
---@field public valueSet insx.kit.LSP.DiagnosticTag[] The tags supported by the client.

---@class insx.kit.LSP.CallHierarchyClientCapabilities
---@field public dynamicRegistration? boolean Whether implementation supports dynamic registration. If this is set to `true`<br>the client supports the new `(TextDocumentRegistrationOptions & StaticRegistrationOptions)`<br>return value for the corresponding server capability as well.

---@class insx.kit.LSP.SemanticTokensClientCapabilities
---@field public dynamicRegistration? boolean Whether implementation supports dynamic registration. If this is set to `true`<br>the client supports the new `(TextDocumentRegistrationOptions & StaticRegistrationOptions)`<br>return value for the corresponding server capability as well.
---@field public requests insx.kit.LSP.SemanticTokensClientCapabilities.requests Which requests the client supports and might send to the server<br>depending on the server's capability. Please note that clients might not<br>show semantic tokens or degrade some of the user experience if a range<br>or full request is advertised by the client but not provided by the<br>server. If for example the client capability `requests.full` and<br>`request.range` are both set to true but the server only provides a<br>range provider the client might not render a minimap correctly or might<br>even decide to not show any semantic tokens at all.
---@field public tokenTypes string[] The token types that the client supports.
---@field public tokenModifiers string[] The token modifiers that the client supports.
---@field public formats insx.kit.LSP.TokenFormat[] The token formats the clients supports.
---@field public overlappingTokenSupport? boolean Whether the client supports tokens that can overlap each other.
---@field public multilineTokenSupport? boolean Whether the client supports tokens that can span multiple lines.
---@field public serverCancelSupport? boolean Whether the client allows the server to actively cancel a<br>semantic token request, e.g. supports returning<br>LSPErrorCodes.ServerCancelled. If a server does the client<br>needs to retrigger the request.<br><br>@since 3.17.0
---@field public augmentsSyntaxTokens? boolean Whether the client uses semantic tokens to augment existing<br>syntax tokens. If set to `true` client side created syntax<br>tokens and semantic tokens are both used for colorization. If<br>set to `false` the client only uses the returned semantic tokens<br>for colorization.<br><br>If the value is `undefined` then the client behavior is not<br>specified.<br><br>@since 3.17.0

---@class insx.kit.LSP.SemanticTokensClientCapabilities.requests
---@field public range? (boolean | {  }) The client will send the `textDocument/semanticTokens/range` request if<br>the server provides a corresponding handler.
---@field public full? (boolean | { delta?: boolean }) The client will send the `textDocument/semanticTokens/full` request if<br>the server provides a corresponding handler.

---@class insx.kit.LSP.LinkedEditingRangeClientCapabilities
---@field public dynamicRegistration? boolean Whether implementation supports dynamic registration. If this is set to `true`<br>the client supports the new `(TextDocumentRegistrationOptions & StaticRegistrationOptions)`<br>return value for the corresponding server capability as well.

---@class insx.kit.LSP.MonikerClientCapabilities
---@field public dynamicRegistration? boolean Whether moniker supports dynamic registration. If this is set to `true`<br>the client supports the new `MonikerRegistrationOptions` return value<br>for the corresponding server capability as well.

---@class insx.kit.LSP.TypeHierarchyClientCapabilities
---@field public dynamicRegistration? boolean Whether implementation supports dynamic registration. If this is set to `true`<br>the client supports the new `(TextDocumentRegistrationOptions & StaticRegistrationOptions)`<br>return value for the corresponding server capability as well.

---@class insx.kit.LSP.InlineValueClientCapabilities
---@field public dynamicRegistration? boolean Whether implementation supports dynamic registration for inline value providers.

---@class insx.kit.LSP.InlayHintClientCapabilities
---@field public dynamicRegistration? boolean Whether inlay hints support dynamic registration.
---@field public resolveSupport? insx.kit.LSP.InlayHintClientCapabilities.resolveSupport Indicates which properties a client can resolve lazily on an inlay<br>hint.

---@class insx.kit.LSP.InlayHintClientCapabilities.resolveSupport
---@field public properties string[] The properties that a client can resolve lazily.

---@class insx.kit.LSP.DiagnosticClientCapabilities
---@field public dynamicRegistration? boolean Whether implementation supports dynamic registration. If this is set to `true`<br>the client supports the new `(TextDocumentRegistrationOptions & StaticRegistrationOptions)`<br>return value for the corresponding server capability as well.
---@field public relatedDocumentSupport? boolean Whether the clients supports related documents for document diagnostic pulls.

---@class insx.kit.LSP.NotebookDocumentSyncClientCapabilities
---@field public dynamicRegistration? boolean Whether implementation supports dynamic registration. If this is<br>set to `true` the client supports the new<br>`(TextDocumentRegistrationOptions & StaticRegistrationOptions)`<br>return value for the corresponding server capability as well.
---@field public executionSummarySupport? boolean The client supports sending execution summary data per cell.

---@class insx.kit.LSP.ShowMessageRequestClientCapabilities
---@field public messageActionItem? insx.kit.LSP.ShowMessageRequestClientCapabilities.messageActionItem Capabilities specific to the `MessageActionItem` type.

---@class insx.kit.LSP.ShowMessageRequestClientCapabilities.messageActionItem
---@field public additionalPropertiesSupport? boolean Whether the client supports additional attributes which<br>are preserved and send back to the server in the<br>request's response.

---@class insx.kit.LSP.ShowDocumentClientCapabilities
---@field public support boolean The client has support for the showDocument<br>request.

---@class insx.kit.LSP.RegularExpressionsClientCapabilities
---@field public engine string The engine's name.
---@field public version? string The engine's version.

---@class insx.kit.LSP.MarkdownClientCapabilities
---@field public parser string The name of the parser.
---@field public version? string The version of the parser.
---@field public allowedTags? string[] A list of HTML tags that the client allows / supports in<br>Markdown.<br><br>@since 3.17.0

---@alias insx.kit.LSP.TextDocumentImplementationResponse (insx.kit.LSP.Definition | insx.kit.LSP.DefinitionLink[] | nil)

---@alias insx.kit.LSP.TextDocumentTypeDefinitionResponse (insx.kit.LSP.Definition | insx.kit.LSP.DefinitionLink[] | nil)

---@alias insx.kit.LSP.WorkspaceWorkspaceFoldersResponse (insx.kit.LSP.WorkspaceFolder[] | nil)

---@alias insx.kit.LSP.WorkspaceConfigurationResponse insx.kit.LSP.LSPAny[]

---@alias insx.kit.LSP.TextDocumentDocumentColorResponse insx.kit.LSP.ColorInformation[]

---@alias insx.kit.LSP.TextDocumentColorPresentationResponse insx.kit.LSP.ColorPresentation[]

---@alias insx.kit.LSP.TextDocumentFoldingRangeResponse (insx.kit.LSP.FoldingRange[] | nil)

---@alias insx.kit.LSP.TextDocumentDeclarationResponse (insx.kit.LSP.Declaration | insx.kit.LSP.DeclarationLink[] | nil)

---@alias insx.kit.LSP.TextDocumentSelectionRangeResponse (insx.kit.LSP.SelectionRange[] | nil)

---@alias insx.kit.LSP.WindowWorkDoneProgressCreateResponse nil

---@alias insx.kit.LSP.TextDocumentPrepareCallHierarchyResponse (insx.kit.LSP.CallHierarchyItem[] | nil)

---@alias insx.kit.LSP.CallHierarchyIncomingCallsResponse (insx.kit.LSP.CallHierarchyIncomingCall[] | nil)

---@alias insx.kit.LSP.CallHierarchyOutgoingCallsResponse (insx.kit.LSP.CallHierarchyOutgoingCall[] | nil)

---@alias insx.kit.LSP.TextDocumentSemanticTokensFullResponse (insx.kit.LSP.SemanticTokens | nil)

---@alias insx.kit.LSP.TextDocumentSemanticTokensFullDeltaResponse (insx.kit.LSP.SemanticTokens | insx.kit.LSP.SemanticTokensDelta | nil)

---@alias insx.kit.LSP.TextDocumentSemanticTokensRangeResponse (insx.kit.LSP.SemanticTokens | nil)

---@alias insx.kit.LSP.WorkspaceSemanticTokensRefreshResponse nil

---@alias insx.kit.LSP.WindowShowDocumentResponse insx.kit.LSP.ShowDocumentResult

---@alias insx.kit.LSP.TextDocumentLinkedEditingRangeResponse (insx.kit.LSP.LinkedEditingRanges | nil)

---@alias insx.kit.LSP.WorkspaceWillCreateFilesResponse (insx.kit.LSP.WorkspaceEdit | nil)

---@alias insx.kit.LSP.WorkspaceWillRenameFilesResponse (insx.kit.LSP.WorkspaceEdit | nil)

---@alias insx.kit.LSP.WorkspaceWillDeleteFilesResponse (insx.kit.LSP.WorkspaceEdit | nil)

---@alias insx.kit.LSP.TextDocumentMonikerResponse (insx.kit.LSP.Moniker[] | nil)

---@alias insx.kit.LSP.TextDocumentPrepareTypeHierarchyResponse (insx.kit.LSP.TypeHierarchyItem[] | nil)

---@alias insx.kit.LSP.TypeHierarchySupertypesResponse (insx.kit.LSP.TypeHierarchyItem[] | nil)

---@alias insx.kit.LSP.TypeHierarchySubtypesResponse (insx.kit.LSP.TypeHierarchyItem[] | nil)

---@alias insx.kit.LSP.TextDocumentInlineValueResponse (insx.kit.LSP.InlineValue[] | nil)

---@alias insx.kit.LSP.WorkspaceInlineValueRefreshResponse nil

---@alias insx.kit.LSP.TextDocumentInlayHintResponse (insx.kit.LSP.InlayHint[] | nil)

---@alias insx.kit.LSP.InlayHintResolveResponse insx.kit.LSP.InlayHint

---@alias insx.kit.LSP.WorkspaceInlayHintRefreshResponse nil

---@alias insx.kit.LSP.TextDocumentDiagnosticResponse insx.kit.LSP.DocumentDiagnosticReport

---@alias insx.kit.LSP.WorkspaceDiagnosticResponse insx.kit.LSP.WorkspaceDiagnosticReport

---@alias insx.kit.LSP.WorkspaceDiagnosticRefreshResponse nil

---@alias insx.kit.LSP.ClientRegisterCapabilityResponse nil

---@alias insx.kit.LSP.ClientUnregisterCapabilityResponse nil

---@alias insx.kit.LSP.InitializeResponse insx.kit.LSP.InitializeResult

---@alias insx.kit.LSP.ShutdownResponse nil

---@alias insx.kit.LSP.WindowShowMessageRequestResponse (insx.kit.LSP.MessageActionItem | nil)

---@alias insx.kit.LSP.TextDocumentWillSaveWaitUntilResponse (insx.kit.LSP.TextEdit[] | nil)

---@alias insx.kit.LSP.TextDocumentCompletionResponse (insx.kit.LSP.CompletionItem[] | insx.kit.LSP.CompletionList | nil)

---@alias insx.kit.LSP.CompletionItemResolveResponse insx.kit.LSP.CompletionItem

---@alias insx.kit.LSP.TextDocumentHoverResponse (insx.kit.LSP.Hover | nil)

---@alias insx.kit.LSP.TextDocumentSignatureHelpResponse (insx.kit.LSP.SignatureHelp | nil)

---@alias insx.kit.LSP.TextDocumentDefinitionResponse (insx.kit.LSP.Definition | insx.kit.LSP.DefinitionLink[] | nil)

---@alias insx.kit.LSP.TextDocumentReferencesResponse (insx.kit.LSP.Location[] | nil)

---@alias insx.kit.LSP.TextDocumentDocumentHighlightResponse (insx.kit.LSP.DocumentHighlight[] | nil)

---@alias insx.kit.LSP.TextDocumentDocumentSymbolResponse (insx.kit.LSP.SymbolInformation[] | insx.kit.LSP.DocumentSymbol[] | nil)

---@alias insx.kit.LSP.TextDocumentCodeActionResponse ((insx.kit.LSP.Command | insx.kit.LSP.CodeAction)[] | nil)

---@alias insx.kit.LSP.CodeActionResolveResponse insx.kit.LSP.CodeAction

---@alias insx.kit.LSP.WorkspaceSymbolResponse (insx.kit.LSP.SymbolInformation[] | insx.kit.LSP.WorkspaceSymbol[] | nil)

---@alias insx.kit.LSP.WorkspaceSymbolResolveResponse insx.kit.LSP.WorkspaceSymbol

---@alias insx.kit.LSP.TextDocumentCodeLensResponse (insx.kit.LSP.CodeLens[] | nil)

---@alias insx.kit.LSP.CodeLensResolveResponse insx.kit.LSP.CodeLens

---@alias insx.kit.LSP.WorkspaceCodeLensRefreshResponse nil

---@alias insx.kit.LSP.TextDocumentDocumentLinkResponse (insx.kit.LSP.DocumentLink[] | nil)

---@alias insx.kit.LSP.DocumentLinkResolveResponse insx.kit.LSP.DocumentLink

---@alias insx.kit.LSP.TextDocumentFormattingResponse (insx.kit.LSP.TextEdit[] | nil)

---@alias insx.kit.LSP.TextDocumentRangeFormattingResponse (insx.kit.LSP.TextEdit[] | nil)

---@alias insx.kit.LSP.TextDocumentOnTypeFormattingResponse (insx.kit.LSP.TextEdit[] | nil)

---@alias insx.kit.LSP.TextDocumentRenameResponse (insx.kit.LSP.WorkspaceEdit | nil)

---@alias insx.kit.LSP.TextDocumentPrepareRenameResponse (insx.kit.LSP.PrepareRenameResult | nil)

---@alias insx.kit.LSP.WorkspaceExecuteCommandResponse (insx.kit.LSP.LSPAny | nil)

---@alias insx.kit.LSP.WorkspaceApplyEditResponse insx.kit.LSP.ApplyWorkspaceEditResult

---@alias insx.kit.LSP.Definition (insx.kit.LSP.Location | insx.kit.LSP.Location[])

---@alias insx.kit.LSP.DefinitionLink insx.kit.LSP.LocationLink

---@alias insx.kit.LSP.LSPArray insx.kit.LSP.LSPAny[]

---@alias insx.kit.LSP.LSPAny (insx.kit.LSP.LSPObject | insx.kit.LSP.LSPArray | string | integer | integer | integer | boolean | nil)

---@alias insx.kit.LSP.Declaration (insx.kit.LSP.Location | insx.kit.LSP.Location[])

---@alias insx.kit.LSP.DeclarationLink insx.kit.LSP.LocationLink

---@alias insx.kit.LSP.InlineValue (insx.kit.LSP.InlineValueText | insx.kit.LSP.InlineValueVariableLookup | insx.kit.LSP.InlineValueEvaluatableExpression)

---@alias insx.kit.LSP.DocumentDiagnosticReport (insx.kit.LSP.RelatedFullDocumentDiagnosticReport | insx.kit.LSP.RelatedUnchangedDocumentDiagnosticReport)

---@alias insx.kit.LSP.PrepareRenameResult (insx.kit.LSP.Range | { range: insx.kit.LSP.Range, placeholder: string } | { defaultBehavior: boolean })

---@alias insx.kit.LSP.ProgressToken (integer | string)

---@alias insx.kit.LSP.DocumentSelector insx.kit.LSP.DocumentFilter[]

---@alias insx.kit.LSP.ChangeAnnotationIdentifier string

---@alias insx.kit.LSP.WorkspaceDocumentDiagnosticReport (insx.kit.LSP.WorkspaceFullDocumentDiagnosticReport | insx.kit.LSP.WorkspaceUnchangedDocumentDiagnosticReport)

---@alias insx.kit.LSP.TextDocumentContentChangeEvent ({ range: insx.kit.LSP.Range, rangeLength?: integer, text: string } | { text: string })

---@alias insx.kit.LSP.MarkedString (string | { language: string, value: string })

---@alias insx.kit.LSP.DocumentFilter (insx.kit.LSP.TextDocumentFilter | insx.kit.LSP.NotebookCellTextDocumentFilter)

---@alias insx.kit.LSP.GlobPattern (insx.kit.LSP.Pattern | insx.kit.LSP.RelativePattern)

---@alias insx.kit.LSP.TextDocumentFilter ({ language: string, scheme?: string, pattern?: string } | { language?: string, scheme: string, pattern?: string } | { language?: string, scheme?: string, pattern: string })

---@alias insx.kit.LSP.NotebookDocumentFilter ({ notebookType: string, scheme?: string, pattern?: string } | { notebookType?: string, scheme: string, pattern?: string } | { notebookType?: string, scheme?: string, pattern: string })

---@alias insx.kit.LSP.Pattern string

return LSP
