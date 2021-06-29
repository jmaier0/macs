% This function searches for '(x)^(0.5)' in the text an replaces it with
% pow((x),(0.5)). This became necessary as C2E2 does only handle pow(,)
% and no other operator. Unfortunately also using power(,) in MATLAB did
% not lead to a different internal representation.
% In detail the function splits the text at each '^' and searches in the
% text before for matching parantheses. Therefore it is essential that
% the base is surround by parantheses!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% WARNING: This is a very crude implementation. If the exponent is
% different than (0.5) or (1/2) then this function will fail, i.e., will
% produce wrong results.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function result=replace_pow(text)

    result = [];
    parts = strsplit(text,'^');
    
    for i=1:size(parts,2)
        openCount = 0;
        closeCount = 0;
        part = char(parts(i));
        
        % cut '(0.5)'
        if i ~= 1
            part = part(6:end);
        end
       
        if i == size(parts,2)
            result = [result(1:end), part];
            continue;
        end
        
        for pos=0:length(part)-1
            if(part(end-pos) == ')')
                closeCount = closeCount + 1;
            end
            
            if(part(end-pos) == '(')
                openCount = openCount + 1;
            end
            
            % evenly matched parantheses
            if openCount == closeCount
                result = [result(1:end), part(1:end-pos-1), 'pow(', ...
                    part(end-pos:end), ',(0.5))'];
                break;
            end
        end
    end
end