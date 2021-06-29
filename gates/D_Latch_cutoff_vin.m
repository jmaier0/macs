function [I_m, I_out] = D_Latch_cutoff_vin(V_in, cutoff, V_m, V_out, feedback_weakening)

    I_in = INV(V_in, V_m);
    I_fb = INV(V_out, V_m);

    I_m = vpa(I_in*cutoff + I_fb/feedback_weakening*(1-cutoff));
    I_out = vpa(INV(V_m, V_out));
    
end