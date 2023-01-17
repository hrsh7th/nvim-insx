# nvim-insx

Flexible insert-mode key mapping manager.

<video src="https://user-images.githubusercontent.com/629908/212733495-f8e5486c-215c-4c01-b53c-b720b9779c3f.mov" width="100%"></video>

### Warning

- This plugin does not support `dot-repeat`.
  - The macro have the highest priority.
- This plugin is *usually* works as expected.
  - Does not aim to support to always work as expected because this plugin uses RegExp 😅
- It is more convenient when used with vim-matchup.
  - The demo image uses with vim-matchup. 👍

### Usage

This plugin does not provide any default mappings.

You should define mapping by yourself like this.

```lua
require('insx.preset.standard').setup()
```

The standard preset enables some of the advanced features.

1. The `<CR>` behaves like a splitjoin

<table>
<tr>
<td>before</td>
<td>

```ts
  foo(|arg1, arg2, [1, 2, 3])
```

</td>
</tr>
<tr>
<td>input</td>
<td>

`<CR>`

</td>
</tr>
<tr>
<td>after</td>
<td>

```ts
  foo(
    arg1,
    arg2,
    [1, 2, 3]
  )
```

</td>
</tr>
</table>

2. The close paren behaves fast wrapping.

<table>
<tr>
<td>before</td>
<td>

```ts
  (|)foo(arg1, arg2, [1, 2, 3])
```

</td>
</tr>
<tr>
<td>input</td>
<td>

`)`

</td>
</tr>
<tr>
<td>after</td>
<td>

```ts
  (foo(arg1, arg2, [1, 2, 3]))
```

</td>
</tr>
</table>


### Status

development stage.

bug report & feature request are welcome.
