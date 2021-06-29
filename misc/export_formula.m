% write C2E2 formula to file
function text = export_formula(name, text, fileID)

    fprintf(fileID,'<dai equation="');
    fprintf(fileID,[name, ' = ',text]);
    fprintf(fileID,'"/>\n');

end