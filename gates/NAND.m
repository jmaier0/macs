function [I_m,I_out] = NAND(V_a, V_b, V_m, V_out)

    parameters;

    I_N1 = uniform_model(V_a - V_m, V_out - V_m, 'N');
    I_N2 = uniform_model(V_b, V_m, 'N');

    I_P1 = uniform_model(V_DD - V_a, V_DD - V_out, 'P');
    I_P2 = uniform_model(V_DD - V_b, V_DD - V_out, 'P');

    I_m = vpa(I_N1 - I_N2);
    I_out = vpa(I_P1 + I_P2 - I_N1);

end