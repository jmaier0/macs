function [I_m, I_out] = D_Latch(V_in, V_m, V_out, feedback_weakening)

    I_in = INV(V_in, V_m);
    I_fb = INV(V_out, V_m);

    I_m = vpa(I_in + I_fb/feedback_weakening);
    I_out = vpa(INV(V_m, V_out));
    
end