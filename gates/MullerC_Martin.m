function [I_1, I_2, I_3, I_out] = MullerC_Martin(V_a, V_b, V_1, V_2, V_3, V_out)

    parameters;

    I_21 = uniform_model(V_a - V_2, V_3 - V_2, 'N');
    I_22 = uniform_model(V_b, V_2, 'N');
        
    I_11 = uniform_model(V_DD - V_a, V_DD - V_1, 'P');
    I_12 = uniform_model(V_1 - V_b, V_1 - V_3, 'P');
    
    I_m = INV(V_out, V_3);
    
    I_1 = vpa(I_11 - I_12);
    I_2 = vpa(I_21 - I_22);
    I_3 = vpa(I_12 - I_21 + I_m/5);
    I_out = vpa(INV(V_3, V_out));

end