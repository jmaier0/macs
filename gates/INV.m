function I_out = INV(V_in, V_out)

    parameters;

    I_N = uniform_model(V_in, V_out, 'N');
    I_P = uniform_model(V_DD - V_in, V_DD - V_out, 'P');
    
    I_out = vpa(I_P - I_N);

end