function [I_1, I_2, I_out] = SchmittTrigger(V_in, V_1, V_2, V_out)

    parameters;

    I_21 = uniform_model(V_in - V_2, V_out - V_2, 'N');
    I_22 = uniform_model(V_in, V_2, 'N');
    I_23 = uniform_model(V_out - V_2, V_DD - V_2, 'N');
    
    I_11 = uniform_model(V_DD - V_in, V_DD - V_1, 'P');
    I_12 = uniform_model(V_1 - V_in, V_1 - V_out, 'P');
    I_13 = uniform_model(V_1 - V_out, V_1, 'P');

    I_1 = vpa(I_11 - I_12 - I_13);
    I_2 = vpa(I_21 - I_22 + I_23);
    I_out = vpa(I_12 - I_21);

end