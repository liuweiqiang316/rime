function date_translator(input, seg)
    if (input == "rq") then
        --- Candidate(type, start, end, text, comment)
        yield(Candidate("date", seg.start, seg._end, os.date("%Y-%m-%d"), ""))
        yield(Candidate("date", seg.start, seg._end, os.date("%Y年%m月%d日"), ""))
    end
    if (input == "wk") then
        arr = { "一", "二", "三", "四", "五", "六" }
        arr[0] = "日"
        local cand1 = Candidate("date", seg.start, seg._end, os.date("星期" .. arr[tonumber(os.date("%w"))]), "")
        local cand2 = Candidate("date", seg.start, seg._end, os.date("周" .. arr[tonumber(os.date("%w"))]), "")
        local cand3 = Candidate("date", seg.start, seg._end, os.date("%Y-%m-%d 星期" .. arr[tonumber(os.date("%w"))]), "")
        cand1.quality = 1
        cand2.quality = 2
        cand3.quality = 3
        yield(cand1)
        yield(cand2)
        yield(cand3)
    end
    if (input == "tt") then
        local cand1 = Candidate("date", seg.start, seg._end, os.date("%Y-%m-%d %H:%M:%S"), "")
        local cand2 = Candidate("date", seg.start, seg._end, os.date("%H:%M:%S"), "")
        cand1.quality = 1
        cand2.quality = 2
        yield(cand1)
        yield(cand2)
    end
end

--- 过滤器：单字在先
function single_char_first_filter(input)
    local l = {}
    for cand in input:iter() do
        if (utf8.len(cand.text) == 1) then
            yield(cand)
        else
            table.insert(l, cand)
        end
    end
    for i, cand in ipairs(l) do
        yield(cand)
    end
end
