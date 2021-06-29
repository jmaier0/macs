% Returns symbol function of uniform mode. Parameter 'type' can be used to
% choose between PMOS ('P') and NMOS ('N').
function I=uniform_model(V_G,V_D,type)

    parameters;

    if strcmp(type,'N')
        NMOS_parameters;
    else
        PMOS_parameters;
    end

    V_Gx = eta*V_t*log(1+exp((V_G-V_T)/(eta*V_t)))+V_T;
    mu_s= mu_0 /(1+theta*(V_Gx-V_T));
    V_Dsat=(L*v_sat/mu_s)*((1+(2*mu_s*(V_Gx-V_T)/(alfa*L*v_sat)))^(0.5)-1);
    V_Dx = V_Dsat*(1-(1/B)*log(1+exp(A*(1-V_D/V_Dsat))));
    l_d=L*log(1+((V_D-V_Dsat)/V_P));
    I=(W*mu_s*C_ox/(L-l_d))*(V_Gx-V_T-0.5*alfa*V_Dx)*V_Dx/(1+(V_Dx*mu_s)/((L-l_d)*v_sat));
    
    %disp('##############')
    %disp(V_Gx)
    %disp(V_Dx)
    %disp(V_Dsat)
    %disp((1/B)*log(1+exp(A*(1-V_D/V_Dsat))))
    
end