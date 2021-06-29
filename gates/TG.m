function I_out = TG(V_in, V_CN, V_CP, V_out, V_DSN, V_SDP)

    parameters;
    
    % not working because the uniMod delivers NaN when V_D becomes smaller
    % than zero!!!
    
    I_N = uniform_model(V_CN - V_in, V_out - V_in, 'N');
    I_P = uniform_model(V_in - V_CP, V_in - V_out, 'P');
    
    if (V_out - V_in < 0)
        I_out = vpa(I_P);
    else
        I_out = vpa(I_N);
    end
    %I_out = vpa(I_P);

end
