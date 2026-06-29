local M = {}

--- Extract a linewise comment prefix from the buffer's `commentstring`.
--- Handles common styles: # %s, // %s, -- %s, " %s, ; %s, % %s, /* %s %/, etc.
function M.get_comment_str()
    local cs = vim.bo.commentstring
    if not cs or cs == '' then
        return '# '
    end

    -- Extract the part before %s
    local pre = cs:match('^(.-)%%s')
    if not pre then
        return '# '
    end

    -- Trim trailing whitespace
    pre = pre:gsub('%s+$', '')

    return pre .. ' '
end

--- Run the original+experimental workflow on the last visual selection.
--- Called from a @e macro via `:lua require('core.custom_macros').run()<CR>`
function M.run()
    -- Use the last visual selection marks (set by 'y' before @e)
    local start_line = vim.fn.line("'<")
    local end_line = vim.fn.line("'>")
    if start_line == 0 or end_line == 0 then
        vim.notify('OrigExp: no previous visual selection', vim.log.levels.WARN)
        return
    end

    local prefix = M.get_comment_str()
    local original_lines = vim.fn.getline(start_line, end_line)

    -- Comment the original lines in-place
    for i = start_line, end_line do
        vim.fn.setline(i, prefix .. vim.fn.getline(i))
    end

    -- Insert header block: ORIGINAL, EXPERIMENTAL, blank line
    local headers = {
        prefix .. 'ORIGINAL',
        prefix .. 'EXPERIMENTAL',
        '',
    }
    vim.fn.append(start_line - 1, headers)

    -- Paste the original code between the blank line and the commented block
    -- After the header append (3 lines at start_line-1):
    --   start_line-1 (unchanged)
    --   ORIGINAL      ← start_line
    --   EXPERIMENTAL  ← start_line+1
    --   (blank)       ← start_line+2   ← insert original here (after this line)
    --   # apple       ← old start_line
    local blank_line_num = start_line + 2
    vim.fn.append(blank_line_num, original_lines)
end

-- Register @e so it calls the Lua function
vim.fn.setreg(
    'e',
    vim.api.nvim_replace_termcodes(
        ":lua require('core.custom_macros').run()<CR>",
        true, false, true
    )
)

return M
