function [I_m, I_nor, I_out] = OR(V_a, V_b, V_m, V_nor, V_out)

    [I_m, I_nor] = NOR(V_a, V_b, V_m, V_nor);
    I_out = INV(V_nor, V_out);
    
end