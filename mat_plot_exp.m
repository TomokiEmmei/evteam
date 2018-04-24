%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%�y�h��z
%�@�E�t�H���_���̑S�t�@�C���ǂݍ��݋@�\������
%�@�Estruct_name���_��������
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;
clear all;      % �����clear all���Ȃ��Ɠ����Ȃ���

%%
% save���邩�ۂ�
 save_flag=1;

% �f�[�^�t�@�C���̃��[�h
filename='180423lfs_test2';
dirname='180423data';
dir_file_name=sprintf('raw/%s/%s', dirname, filename);
%dir(sprintf('raw/%s', dirname));
load(dir_file_name);
who_array=who; % work space���̕ϐ����X�g��z��Ɋi�[
struct_name = char(who_array(5));        % clear all���Ă���΃��[�N�X�y�[�X�ϐ��͍\���̂���

% ���ԃf�[�^�̎擾
time = eval([struct_name,'.X(1).Data']);

% �ϐ��̌����擾
n = size(eval([struct_name,'.Y']),2);

% �ϐ��̎擾
for k=1:n
    % �ϐ������擾
    name = eval([struct_name,'.Y(k).Name']);    % �ϐ���������̎擾
    dq_p = strfind(name,'"');                   % "�̈ʒu���擾
    name = name(dq_p(end-1)+1:dq_p(end)-1);     % �Ō��"xxxx"�̕����̂ݒ��o

    % �ϐ����ɂł��Ȃ��������A���_�[�o�[�ɒu��
    name = strrep(name,' ','_');
    name = strrep(name,'!','_');
    name = strrep(name,'#','_');
    name = strrep(name,'$','_');
    name = strrep(name,'%','_');
    name = strrep(name,'&','_');
    name = strrep(name,'''','_');
    name = strrep(name,'(','_');
    name = strrep(name,')','_');
    name = strrep(name,'~','_');
    name = strrep(name,'|','_');
    name = strrep(name,'@','_');
    name = strrep(name,'{','_');
    name = strrep(name,'}','_');
    name = strrep(name,'<','_');
    name = strrep(name,'>','_');
    name = strrep(name,'?','_');
    name = strrep(name,'\','_');
    name = strrep(name,'+','_');
    name = strrep(name,'-','_');    
    name = strrep(name,'*','_');
    name = strrep(name,'/','_');
    name = genvarname(name);        % �ŏI��i
    
    % �ϐ����擾
    eval([name,'=',struct_name,'.Y(k).Data;'])
end

% �ǂݍ��݉ߒ��Ŏg�����ϐ����폜
clear dq_p m n k name who_array dir_file_name;

% �p�����[�^�𕜌�������ꍇ���̃X�N���v�g��L���ɂ���
%fpev2_kanon_param_nc;

%�ۑ�
if save_flag==1
    savedir=sprintf('expand/%s', dirname);
    if  exist('expand') ~=7
        mkdir expand
    end
    if  exist(savedir) ~=7
        mkdir(savedir)
    end
savename=sprintf('expand/%s/%s_expand', dirname, struct_name);
save(savename);
clear savename dirname filename;
end

%% �f�[�^�̕ۑ��ƃv���b�g
xmin = 0;
xmax = 10;

%Yaw rate
if  exist('gamma') ==1
    hfig = figure;%('Position',[50 50 450 350]);
    plot(time, gamma_LPF+2.18, 'r', 'linewidth',3); hold on;
    xlabel('Time [s]');
    ylabel('Yaw rate [rad/s]');
    pfig = pubfig(hfig);
    pfig.LegendLoc = 'best';
    xlim([xmin, xmax]);

    if save_flag==1
        savename = sprintf('fig/%s_gamma',struct_name);
        expfig(savename,'-png'); %,'-pdf','-emf','-png','-fig'
    end
end

% Wheel angular velocity
if  [exist('w_front_left'), exist('w_front_right'), exist('w_rear_left'), exist('w_rear_right')] ==[1, 1, 1, 1]
    hfig = figure;
    xlabel('Time [sec]');
    ylabel('Angular velocity [rad/s]');
    plot(time, w_front_left, 'r', 'linewidth',3); hold on;
    plot(time, w_front_right, 'b --', 'linewidth',3);
    plot(time, w_rear_left, 'k', 'linewidth',3); 
    plot(time, w_rear_right, 'g --', 'linewidth',3);
    legend('fl', 'fr', 'rl', 'rr', 1);
    pfig = pubfig(hfig);
    pfig.LegendLoc = 'best';
    xlim([xmin, xmax]);
    if save_flag==1
        savename = sprintf('fig/%s_w',struct_name);
        expfig(savename,'-png');
    end
end

% Lateral force sensor
if  [exist('Fy_fl'), exist('Fy_fr'), exist('Fy_rl'), exist('Fy_rr')] ==[1, 1, 1, 1]
    hfig = figure;
    plot(time, Fy_fl, 'r', 'linewidth',3); hold on;
    plot(time, Fy_fr, 'b.-', 'linewidth',3);
    plot(time, Fy_rl, 'k--', 'linewidth',3);
    plot(time, Fy_rr, 'g--', 'linewidth',3);
    legend('fl', 'fr', 'rl', 'rr', 1, 'Location','northeast');
    xlabel('Time [sec]');
    ylabel('Torque [Nm]');
    pfig = pubfig(hfig);
    pfig.LegendLoc = 'best';
    xlim([xmin, xmax]);
    % ylim([ymin, ymax]);
    if save_flag==1
        savename = sprintf('fig/%s_torque',struct_name);
        expfig(savename,'-pdf','-emf','-png');
    end
end

% Encoder value of EPS
if  [exist('rear_eps_enc'), exist('front_eps_enc')] ==[1, 1]
    hfig = figure;
    xlabel('Time [sec]');
    ylabel('EPS angle [rad]');
    plot(time, front_eps_enc, 'r', 'linewidth',3); hold on;
    plot(time, rear_eps_enc, 'b --', 'linewidth',3);
    legend('front', 'rear', 1);
    pfig = pubfig(hfig);
    pfig.LegendLoc = 'best';
    xlim([xmin, xmax]);
    if save_flag==1
        savename = sprintf('fig/%s_eps_enc',struct_name);
        expfig(savename,'-png');
    end
end

% EPS torque
if  [exist('eps_trq_f'), exist('eps_trq_r')] ==[1, 1]
    hfig = figure;
    xlabel('Time [sec]');
    ylabel('EPS torquw [Nm]');
    plot(time, eps_trq_f, 'r', 'linewidth',3); hold on;
    plot(time, eps_trq_r, 'b --', 'linewidth',3);
    legend('front', 'rear', 1);
    pfig = pubfig(hfig);
    pfig.LegendLoc = 'best';
    xlim([xmin, xmax]);
    if save_flag==1
        savename = sprintf('fig/%s_eps_trq',struct_name);
        expfig(savename,'-png');
    end
end

close all;