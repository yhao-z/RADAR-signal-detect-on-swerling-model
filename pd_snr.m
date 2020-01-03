clear; clc;
Pd0 = [];Pd1 = [];Pd2 = [];Pd3= [];Pd4 = [];   %������
Np = 10;%����λ��۵Ĵ���
Pfa = 1e-6;%�龯����
Vt = v_limit(Np,Pfa);%������ 
N=1000; %���ؿ���ѭ���Ĵ���

%--------------------------------------------------------------------------
%���ؿ���ѭ����
for Mc = 1:N   %ѭ������ΪN
%--------------------------------------------------------------------------
%�����м�����Լ��洢����
    X0 = [];X1 = [];X2 = [];X3 = [];X4 = [];
    X0sum = [];X1sum = [];X2sum = [];X3sum = [];X4sum = [];
    S0 = [];S1 = [];S2 = [];S3 = [];S4 = [];
    A0 = [];A1 = [];A2 = [];A3 = [];A4 = [];
%--------------------------------------------------------------------------
for Num = 0:20
    SNR = Num-10; % �����
    %----------------------------------------------------------------------
    %�趨��������
    sig = sqrt(1/2);  %����ʵ���鲿�ı�׼��
    sigs1 = sqrt((sig^2)*(10^(SNR/10)));      %swerling I/II �����ֲ���Ӧ���ڲ���˹�ֲ��ı�׼��                                            
    sigs2 = sqrt((1/2)*(sig^2)*(10^(SNR/10)));  %%swerling III/IV �����ֲ���Ӧ���ڲ���˹�ֲ��ı�׼��
    %-----------------------------------------------
    %Swerling 0
    A0(Num+1,1) = sqrt(2*(sig^2)*(10^(SNR/10))); % ����                               
    S0(Num+1,:) = A0(Num+1,1)*exp(1i*2*pi*rand(1,Np)); %�źţ��������Ⱥ���λ�ģ���21*10�ľ���10������������Np��    
    X0(Num+1,:) = abs(awgn(S0(Num+1,:),SNR,'measured')).^2;  %Ϊ�źż����������ȵĸ�˹��������Ȼ�󾭹�ƽ���첨������ƽ����
    X0sum(Num+1,Mc) = sum(X0(Num+1,:));     %����λ��۹�10��
    if X0sum(Num+1,Mc) >= Vt
        Sum0(Num+1,Mc) = 1;%  �ڼ��η���  �������ź�  Ϊ1
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

