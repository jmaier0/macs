function [I_Q, I_mQ, I_NQ, I_mNQ] = RS_Latch(V_R, V_S, V_Q, V_mQ, V_NQ, V_mNQ)

    [I_mQ, I_Q] = NOR(V_R, V_NQ, V_mQ, V_Q);
    [I_mNQ, I_NQ] = NOR(V_S, V_Q, V_mNQ, V_NQ);

end