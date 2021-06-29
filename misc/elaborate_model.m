% Returns symbol function of uniform mode. Parameter 'type' can be used to
% choose between PMOS ('P') and NMOS ('N').
function [I,V_Dsat]=elaborate_model(V_G,V_D,type)

    parameters;

    if strcmp(type,'N')
        NMOS_parameters;
    else
        PMOS_parameters;
    end

    if V_G < V_T
        I=0;
        V_Dsat=0;
        return
    end
    
    mu_s= mu_0 /(1+theta*(V_G-V_T));
    V_Dsat=(L*v_sat/mu_s)*((1+(2*mu_s*(V_G-V_T)/(alfa*L*v_sat)))^(0.5)-1);
    l_d=L*log(1+((V_D-V_Dsat)/V_P));
		      %    a = (1.602e-19*1.68e17)/(3*11.68*8.854e-14);
%    a =1e11;
%    l_d=sqrt((V_D-V_Dsat)/a) / 100;
%    l_d = (V_D - V_Dsat)*1e-8;  
           
    if V_D > V_Dsat
        % SAT
      I = L/(L-l_d);
%      I=1;
        V_Dx=V_Dsat;
    else
        %OHM
        I = 1;
        V_Dx=V_D;
    end
    
    I = I* (W*mu_s*C_ox/L)*(V_G-V_T-0.5*alfa*V_Dx)*V_Dx/(1+(V_Dx*mu_s)/(L*v_sat));
    
end
