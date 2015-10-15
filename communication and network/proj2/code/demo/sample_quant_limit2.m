fs=10000;
T=1;
fc=31.415926;
B=300;
quantization_bits=4;
esp=1e-10;
normalized_effecive_power_dB=-10;

Amax=1;
step_size=(2*Amax/(2^quantization_bits));

t=0:1/fs:T;
rs=randn(1,length(t));
frs=fft(rs);
mask=zeros(1,length(t));
endF=round((length(t)-1)/fs*B);
mask(1:endF+1)=mask(1:endF+1)+1;
mask(end-endF+1:end)=mask(end-endF+1:end)+1;
ffrs=frs.*mask;
s=ifft(ffrs)*sqrt(fs/2/B);

s=s*sqrt(10^(normalized_effecive_power_dB/10));  %�ı���Դ�Ĺ���

sq=(s-(s-(Amax-esp)).*floor(sign(s-(Amax-esp))/2+0.7)+(-Amax-s).*floor(sign(-Amax-s)/2+0.7))/step_size;
dsq=(floor(sq)+0.5)*step_size;
lsq=sq*step_size;

elsq=lsq-s;
figure;plot(t,s);hold on;plot(t,lsq,'r');
title('�޷���Ч��');xlabel('t (s)');ylabel('��������');legend('�޷�ǰ','�޷���');
[(elsq*elsq')/length(elsq) (elsq*elsq')/(s*s')]
%��ʾ�������ʡ�����������źŵĹ��ʱ�
esq=dsq-s;

figure;plot(s,'.');hold on; plot(dsq,'r.');
title('�޷�������Ч��');xlabel('t (s)');ylabel('��������');legend('ԭʼ����','�޷�������');
figure;
plot((0:length(s)-1)/length(s)*fs,20*log10(abs(fft(s)/sqrt(length(s))/sqrt(T))));hold on;
plot((0:length(s)-1)/length(s)*fs,20*log10(abs(fft(dsq)/sqrt(length(s))/sqrt(T))),'r');
title('ԭʼ�������޷�������Ĺ�����');xlabel('Ƶ��(Hz)');ylabel('������ (dB)');legend('ԭʼ����','�޷�������');
%��ʾ�����ף�ԭʼ�������޷�������Ĳ���

recover_sq=ifft(fft(dsq).*mask);
recover_esq=recover_sq-s;
10*log10([mean(s.*s) mean(esq.*esq) mean(recover_esq.*recover_esq)])
%��ʾ�źŹ��ʡ��޷�����ֱ���ع����������ʡ��޷������˲��ع�����������
