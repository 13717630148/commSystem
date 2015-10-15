fs=10000;
T=1;
B=300;
source_power=0.0001;
t=0:1/fs:T;
rs=randn(1,length(t));
frs=fft(rs);
mask=zeros(1,length(t));
endF=round((length(t)-1)/fs*B);
mask(1:endF+1)=mask(1:endF+1)+1;
mask(end-endF+1:end)=mask(end-endF+1:end)+1;
ffrs=frs.*mask;
s=ifft(ffrs)*sqrt(fs/2/B);

s=s*sqrt(source_power);  %�ı���Դ�Ĺ���

s10=s*10;   %̨��Ϊ0.1
s100=s*100;   %̨��Ϊ0.01
% ds10=round(s10)/10;
% ds100=round(s100)/100;
ds10=(floor(s10)+0.5)/10;
ds100=(floor(s100)+0.5)/100;
es10=ds10-s;
es100=ds100-s;
10*log10([mean(s.*s) mean(es10.*es10) mean(es100.*es100)])
%�ֱ���ʾ���źŹ��ʡ�ֱ���ع���̨��0.1��0.01���������ʣ���λΪdB
%���Թ۲쵽�������ʵı仯��Ӱ��������������
figure;plot(t,s,'.');hold on; plot(t,ds10,'r.');plot(t,ds100,'g.');
title('ԭʼ������������Ĳ���');xlabel('ʱ��t  (s)');ylabel('x(t)');legend('ԭʼ����','̨��0.1','̨��0.01');
figure;
plot((0:length(s)-1)/length(s)*fs,20*log10(abs(fft(s)/sqrt(length(s))/sqrt(T))));hold on;
plot((0:length(s)-1)/length(s)*fs,20*log10(abs(fft(ds10)/sqrt(length(s))/sqrt(T))),'r');
plot((0:length(s)-1)/length(s)*fs,20*log10(abs(fft(ds100)/sqrt(length(s))/sqrt(T))),'g');
title('ԭʼ������������Ĳ����Ĺ�����');xlabel('Ƶ��f (Hz)');ylabel('������ (dB)');legend('ԭʼ����','̨��0.1','̨��0.01');
%�۲�����ǰ���Ƶ�ף����Կ�����������������ƽ���������е�Ƶ���ϣ������ʱ�ߣ����������������ܶȾͽ���
%��ˣ�������������Ҳ�����Ų����ʵ����Ӷ����ͣ�������������ǹ�������
%�������� = ������ / 2���źŴ���

recover_s10=ifft(fft(ds10).*mask);
recover_s100=ifft(fft(ds100).*mask);
recover_es10=recover_s10-s;
recover_es100=recover_s100-s;
10*log10([mean(s.*s) mean(es10.*es10) mean(es100.*es100) mean(recover_es10.*recover_es10) mean(recover_es100.*recover_es100)])
%�ֱ���ʾ���źŹ��ʡ�ֱ���ع���̨��0.1��0.01���������ʡ��˲��ع���̨��0.1��0.01���ع��������ʣ���λΪdB
figure;hist(es10,100);title('ֱ���ع���̨��0.1��������ƽ�ֲ�');
xlabel('������ƽȡֵ');ylabel('��Ӧ������ƽ��ͳ����');
figure;hist(recover_es10,100);title('�˲��ع���̨��0.1��������ƽ�ֲ�');
xlabel('������ƽȡֵ');ylabel('��Ӧ������ƽ��ͳ����');
%�۲�ֱ�����������ķֲ����Ǿ��ȷֲ������þ��ȷֲ���������ͨ����ͨ�˲��Ժ󣬲������ʱ�С�ˣ����ҷֲ����ָ�˹�ֲ�
%��ԭ���˲����������ǰ�����ɸ�����ļ�Ȩ�ͣ�����������֮����ֶ����ԣ�Ҳ����˵����������ֲ�����������ͣ����²�����ȫͬ�ֲ��ģ��������Ͽ����и�˹�������ơ�
