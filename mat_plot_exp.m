%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%【宿題】
%　・フォルダ内の全ファイル読み込み機能をつける
%　・struct_nameがダメすぎる
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;
clear all;      % これはclear allしないと動かないよ

%%
% saveするか否か
 save_flag=1;

% データファイルのロード
filename='180423lfs_test2';
dirname='180423data';
dir_file_name=sprintf('raw/%s/%s', dirname, filename);
%dir(sprintf('raw/%s', dirname));
load(dir_file_name);
who_array=who; % work space内の変数リストを配列に格納
struct_name = char(who_array(5));        % clear allしていればワークスペース変数は構造体だけ

% 時間データの取得
time = eval([struct_name,'.X(1).Data']);

% 変数の個数を取得
n = size(eval([struct_name,'.Y']),2);

% 変数の取得
for k=1:n
    % 変数名を取得
    name = eval([struct_name,'.Y(k).Name']);    % 変数名文字列の取得
    dq_p = strfind(name,'"');                   % "の位置を取得
    name = name(dq_p(end-1)+1:dq_p(end)-1);     % 最後の"xxxx"の部分のみ抽出

    % 変数名にできない文字をアンダーバーに置換
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
    name = genvarname(name);        % 最終手段
    
    % 変数を取得
    eval([name,'=',struct_name,'.Y(k).Data;'])
end

% 読み込み過程で使った変数を削除
clear dq_p m n k name who_array dir_file_name;

% パラメータを復元させる場合下のスクリプトを有効にする
%fpev2_kanon_param_nc;

%保存
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

%% データの保存とプロット
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