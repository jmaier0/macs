function [I_1, I_2, I_3, I_4, I_5, I_out] = MullerC_Sutherland(V_a, V_b, V_1, V_2, V_3, V_4, V_5, V_out)

    parameters;

    I_21 = uniform_model(V_a - V_2, V_5 - V_2, 'N');
    I_22 = uniform_model(V_b, V_2, 'N');
    I_31 = uniform_model(V_out - V_3, V_5 - V_3, 'N');
    I_32 = uniform_model(V_a, V_3, 'N');
    I_33 = uniform_model(V_b, V_3, 'N');
    I_out2 = uniform_model(V_5, V_out, 'N');
    
    I_11 = uniform_model(V_DD - V_a, V_DD - V_1, 'P');
    I_12 = uniform_model(V_1 - V_b, V_1 - V_5, 'P');
    I_41 = uniform_model(V_DD - V_a, V_DD - V_4, 'P');
    I_42 = uniform_model(V_DD - V_b, V_DD - V_4, 'P');
    I_43 = uniform_model(V_4 - V_out, V_4 - V_5, 'P');  
    I_out1 = uniform_model(V_DD - V_5, V_DD - V_out, 'P');  

    I_1 = vpa(I_11 - I_12);
    I_2 = vpa(I_21 - I_22);
    I_3 = vpa(I_31 - I_32 - I_33);
    I_4 = vpa(I_41 + I_42 - I_43);
    I_5 = vpa(I_43 + I_12 - I_21 - I_31);
    I_out = vpa(I_out1 - I_out2);

end