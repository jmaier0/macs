function [I_int1, I_int2, I_out] = D_Latch_TG(V_in, V_C1, V_C2, V_int1, V_int2, V_out)

    I_tg1 = TG(V_in, V_C1, V_C2, V_int1);
    I_fo = INV(V_int1, V_out);
    I_fb = INV(V_out, V_int2);
    I_tg2 = TG(V_int2, V_C2, V_C1, V_int1);

    I_int1 = vpa(I_tg1+I_tg2);
    I_int2 = vpa(I_fb-I_tg2);
    I_out = vpa(I_fo);
    
end