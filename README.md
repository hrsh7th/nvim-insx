# nvim-insx

Flexible key mapping manager.

<video src="https://user-images.githubusercontent.com/629908/212733495-f8e5486c-215c-4c01-b53c-b720b9779c3f.mov" width="100%"></video>

### Warning

- This plugin does not support `dot-repeat`.
  - The macro have the highest priority.
- This plugin is *usually* works as expected.
  - Does not aim to support to always work as expected because this plugin uses RegExp 😅
- It is more convenient when used with vim-matchup.
  - The demo image uses with vim-matchup. 👍
- This plugin provides cmdline pairwise features.
  - But it's limited support. Not all public APIs provided by this plugin support cmdline mode.

### Usage

This plugin does not provide any default mappings.

You should define mapping by yourself like this.

```lua
require('insx.preset.standard').setup()
```

The standard preset enables some of the advanced features.

#### 1. The `<CR>` behaves like a splitjoin

```ts
foo(|arg1, arg2, [1, 2, 3])
```

```
<CR>
```

↓↓↓

```ts
foo(
  |arg1,
  arg2,
  [1, 2, 3]
)
```

#### 2. The `<C-]>` behaves fast wrapping.

```ts
(|)foo(arg1, arg2, [1, 2, 3])
```

```
<C-]>
````

↓↓↓

```ts
(foo(arg1, arg2, [1, 2, 3])|)
```



### Status

The API is stable except helper related APIs.

bug report & feature request are welcome.

