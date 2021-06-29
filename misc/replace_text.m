% replace each occurence of text number n in remove by text number n in
% replacements
function text = replace_text(text, remove, replacements)

    for i=1:size(remove,1)
        text = strrep(text, strtrim(remove(i,:)), strtrim(replacements(i,:)));
    end

    text = replace_pow(text);
end