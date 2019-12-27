function Vl= v_limit(a1,a2);
Np = a1;
Pfa = a2;
Nfa = 1/Pfa;
Vt = [];
Vt(1) = Np-sqrt(Np)+2.3*(sqrt(-(log(Pfa)/log(10)))*((sqrt(-((log(Pfa))/(log(10))))+sqrt(Np)-1)));
Vt(2) = Vt(1)-(((1/2)^((Np/Nfa))-gammainc(Vt(1),Np)))/(-((exp(-Vt(1))*(Vt(1)^(Np-1)))/factorial(Np-1)));
i = 2;
while abs(Vt(i)-Vt(i-1))>=(Vt(i-1)/10000)
    i = i+1;
    Vt(i) = Vt(i-1)-(((1/2)^((Np/Nfa))-gammainc(Vt(i-1),Np)))/(-((exp(-Vt(i-1))*(Vt(i-1)^(Np-1)))/factorial(Np-1)));
end;
Vl = Vt(i);


