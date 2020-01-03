clear; clc;
Pd0 = [];Pd1 = [];Pd2 = [];Pd3= [];Pd4 = [];   %检测概率
Np = 10;%非相参积累的次数
Pfa = 1e-6;%虚警概率
Vt = v_limit(Np,Pfa);%求门限 
N=1000; %蒙特卡洛循环的次数

%--------------------------------------------------------------------------
%蒙特卡洛循环，
for Mc = 1:N   %循环次数为N
%--------------------------------------------------------------------------
%定义中间变量以及存储矩阵
    X0 = [];X1 = [];X2 = [];X3 = [];X4 = [];
    X0sum = [];X1sum = [];X2sum = [];X3sum = [];X4sum = [];
    S0 = [];S1 = [];S2 = [];S3 = [];S4 = [];
    A0 = [];A1 = [];A2 = [];A3 = [];A4 = [];
%--------------------------------------------------------------------------
for Num = 0:20
    SNR = Num-10; % 信噪比
    %----------------------------------------------------------------------
    %设定噪声功率
    sig = sqrt(1/2);  %噪声实部虚部的标准差
    sigs1 = sqrt((sig^2)*(10^(SNR/10)));      %swerling I/II 卡方分布对应的内部高斯分布的标准差                                            
    sigs2 = sqrt((1/2)*(sig^2)*(10^(SNR/10)));  %%swerling III/IV 卡方分布对应的内部高斯分布的标准差
    %-----------------------------------------------
    %Swerling 0
    A0(Num+1,1) = sqrt(2*(sig^2)*(10^(SNR/10))); % 幅度                               
    S0(Num+1,:) = A0(Num+1,1)*exp(1i*2*pi*rand(1,Np)); %信号（包含幅度和相位的），21*10的矩阵，10次脉冲体现在Np上    
    X0(Num+1,:) = abs(awgn(S0(Num+1,:),SNR,'measured')).^2;  %为信号加入符合信噪比的高斯白噪声，然后经过平方检波（幅度平方）
    X0sum(Num+1,Mc) = sum(X0(Num+1,:));     %非相参积累共10次
    if X0sum(Num+1,Mc) >= Vt
        Sum0(Num+1,Mc) = 1;%  第几次仿真  检测出了信号  为1
    end
    %------------------------------------------------
    %Swerling 1
    A1(Num+1,1) = sqrt(((sigs1*randn(1))^2)+((sigs1*randn(1))^2));
    S1(Num+1,:) = A1(Num+1,1)*exp(1i*2*pi*rand(1,Np));
    X1(Num+1,:) = abs(awgn(S1(Num+1,:),SNR,'measured')).^2;
    X1sum(Num+1,Mc) = sum(X1(Num+1,:));
    if X1sum(Num+1,Mc) >= Vt
        Sum1(Num+1,Mc) = 1;
    end
    %------------------------------------------------
    %Swerling 2
    A2(Num+1,:) = sqrt(((sigs1*randn(1,Np)).^2)+((sigs1*randn(1,Np)).^2));
    S2(Num+1,:) = A2(Num+1,:).*exp(1i*2*pi*rand(1,Np));
    X2(Num+1,:) = abs(awgn(S2(Num+1,:),SNR,'measured')).^2;
    X2sum(Num+1,Mc) = sum(X2(Num+1,:));
    if X2sum(Num+1,Mc) >= Vt
        Sum2(Num+1,Mc) = 1;
    end
    %-------------------------------------------------
    %Swerling 3
    A3(Num+1,1) =  sqrt(((sigs2*randn(1))^2)+((sigs2*randn(1))^2)+((sigs2*randn(1))^2)+((sigs2*randn(1))^2));
    S3(Num+1,:) =  A3(Num+1,1)*exp(1i*2*pi*rand(1,10));
    X3(Num+1,:) = abs(awgn(S3(Num+1,:),SNR,'measured')).^2;
    X3sum(Num+1,:) = sum(X3(Num+1,:));
    if X3sum(Num+1,:) >= Vt 
        Sum3(Num+1,Mc) = 1;
    end
    %--------------------------------------------------
    %Swerling 4
    A4(Num+1,:) = sqrt(((sigs2*randn(1,Np)).^2)+((sigs2*randn(1,Np)).^2)+((sigs2*randn(1,Np)).^2)+((sigs2*randn(1,Np)).^2));
    S4(Num+1,:) = A4(Num+1,:).*exp(1i*2*pi*rand(1,Np));
    X4(Num+1,:) = abs(awgn(S4(Num+1,:),SNR,'measured')).^2;
    X4sum(Num+1,Mc) = sum(X4(Num+1,:));
    if X4sum(Num+1,Mc) >= Vt
        Sum4(Num+1,Mc) = 1;
    end
end
end
for i =0:20
Pd0(i+1) = sum(Sum0(i+1,:))./(Mc);
Pd1(i+1) = sum(Sum1(i+1,:))./(Mc);
Pd2(i+1) = sum(Sum2(i+1,:))./(Mc);
Pd3(i+1) = sum(Sum3(i+1,:))./(Mc);
Pd4(i+1) = sum(Sum4(i+1,:))./(Mc);
end
% profile view
xx=-10:1:10;
figure(1)
subplot()
plot((-10:10),Pd0);
xlabel('SNR/dB');
ylabel('Pd');
title('Swerling 0');

figure(2)
plot((-10:10),Pd1);
xlabel('SNR/dB');
ylabel('Pd');
title('Swerling 1');

figure(3)
plot((-10:10),Pd2);
xlabel('SNR/dB');
ylabel('Pd');
title('Swerling 2');

figure(4)
plot((-10:10),Pd3);
xlabel('SNR/dB');
ylabel('Pd');
title('Swerling 3');

figure(5)
plot((-10:10),Pd4);
xlabel('SNR/dB');
ylabel('Pd');
title('Swerling 4');

figure(6)
hold on

plot(xx,Pd1,'b*',xx,Pd2,'b-',xx,Pd3,'b--',xx,Pd0,'b:',xx,Pd4,'b-.');
xlabel('SNR/dB');
ylabel('Pd');
legend('Swerling 1','Swerling 2','Swerling3','Swerling 0','Swerling 4')

