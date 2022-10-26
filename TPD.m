% 特プロ　課題④　2点弁別閾検査
% start from 2022/02  
% 実験はすべてアナログ
% アナログデータを取りまとめて、心理物理曲線を得る

%被験者名
defaultanswer = {'Egashira'};
subject = inputdlg({'subject'},'Input the answer',1,defaultanswer);
subject_name = char(subject(1));


%【課題1】刺激強度行列を作成
%行列内に8の刺激強度を記載
stim_palm = [1,2,5,7,8,9,10,13];
stim_finger = [0.5,1,2,3,4,5,7,11];


%【課題2】ふたつの身体部位ごとに、回答率を入力
%output_palm = [0,0,10,40,90,90,100,100];
%output_finger = [0,50,100,100,100,100,100,100];

%変数が増えすぎないようにデータをcsvファイルに入れて読み込む
%strcatは文字列の結合
output_palm = readmatrix(strcat(subject_name, ".csv"), 'Range', 'A2:H2');
output_finger = readmatrix(strcat(subject_name, ".csv"), 'Range', 'A1:H1');


%【課題3】ひとつのfigureに指と腕、ふたつの心理物理曲線を描画
%ひとつのfigureに指と腕、ふたつの心理物理曲線を描画
%軸名、数値、凡例などを適切なフォントやサイズで



%【課題4】ひとつのfigureに指と腕、ふたつの心理物理曲線を描画

n = linspace(10,10,8)'; %試行回数

%転置する
stim_palm = stim_palm';
result_palm = output_palm';

stim_finger = stim_finger';
result_finger = output_finger';

%プロビット回帰モデル
b_palm = glmfit(stim_palm,[result_palm n],'binomial','Link','probit');
b_finger = glmfit(stim_finger,[result_finger n],'binomial','Link','probit');

%xのかさ増し
stim_x = linspace(0,15);
n = linspace(10,10);

%推定成功回数を計算
yfit_palm = glmval(b_palm,stim_x,'probit','Size',n);
yfit_finger = glmval(b_finger,stim_x,'probit','Size',n);


%【課題5】ふたつの身体部位の触覚感度を定量評価
%定量評価指標として何を求めるか？

fileName = strcat(subject_name, "_result.txt");
fileId = fopen(fileName, 'w');

%閾値...2点と判別できる最小の幅
%y=50のときのx

[x1, x2, y1, y2] = find_plot(stim_x, yfit_palm, 50); %座標
X_palm_50 = calc_threshold(x1, x2, y1, y2, 50); %閾値
fprintf(fileId, 'y = %2.0f, x = %4.2f (Palm)\n',50, X_palm_50); %ファイルに書き込む

%s = ['palm,50%:', num2str(X)]; %num2strは数値を文字列に変換
%disp(s);

[x1, x2, y1, y2] = find_plot(stim_x, yfit_finger, 50);
X_finger_50 = calc_threshold(x1, x2, y1, y2, 50);
fprintf(fileId, 'y = %2.0f, x = %4.2f (Finger)\n',50, X_finger_50);


%感度...刺激の変化にどれくらい敏感か
%(y=75のときのx)-(y=25のときのx)

[x1, x2, y1, y2] = find_plot(stim_x, yfit_palm, 25);
X_palm_25 = calc_threshold(x1, x2, y1, y2, 25);
fprintf(fileId, 'y = %2.0f, x = %4.2f (Palm)\n',25, X_palm_25);

[x1, x2, y1, y2] = find_plot(stim_x, yfit_palm, 75);
X_palm_75 = calc_threshold(x1, x2, y1, y2, 75);
fprintf(fileId, 'y = %2.0f, x = %4.2f (Palm)\n',75, X_palm_75);

sensitivity_palm = X_palm_75 - X_palm_25;


[x1, x2, y1, y2] = find_plot(stim_x, yfit_finger, 25);
X_finger_25 = calc_threshold(x1, x2, y1, y2, 25);
fprintf(fileId, 'y = %2.0f, x = %4.2f (Finger)\n',25, X_finger_25);

[x1, x2, y1, y2] = find_plot(stim_x, yfit_finger, 75);
X_finger_75 = calc_threshold(x1, x2, y1, y2, 75);
fprintf(fileId, 'y = %2.0f, x = %4.2f (Finger)\n',75, X_finger_75);

sensitivity_finger = X_finger_75 - X_finger_25;

fprintf(fileId, '閾値: %4.2f(Palm), %4.2f(Finger)\n',X_palm_50,X_finger_50);
fprintf(fileId, '感度: %4.2f(Palm), %4.2f(Finger)\n',sensitivity_palm,sensitivity_finger);


%図示

figure1 = figure(1);

hold on 
p3 = plot(stim_x,yfit_finger*10,'-', 'Color','[1 0.6 0.6]', 'LineWidth', 5);
hold off

hold on 
p4 = plot(stim_x,yfit_palm*10,'-', 'Color','[0.6 0.6 1]', 'LineWidth', 5);
hold off

hold on
p1 = plot(stim_finger,output_finger*10,'r.','MarkerSize',40); %点でプロット
hold off

hold on %前の図も残るように固定
p2 =plot(stim_palm,output_palm*10,'b.','MarkerSize',40);
hold off

%{
hold on
p5 = plot(stim_finger,output_finger*10,'wo','MarkerSize',11);
hold off

hold on
p6 = plot(stim_palm,output_palm*10,'wo','MarkerSize',11);
hold off
%}

title('two-point discrimination'); %タイトル

xlabel('Distance [mm]'); %x軸の名前
ylabel('% of "Two Points" Judgement'); %y軸の名前

xticks([0,1,2,3,4,5,6,7,8,9,10,11,12,13]); %メモリの刻み
%xticks([0,5,10,13]);

grid on %グリッド
box on %外枠

fontsize = 16; %フォントサイズの設定
h = gca; %図をhとしてset関数で変更できるようにする
set(h,'fontsize',fontsize);
%h.YLabel.FontSize = 26;

%legend([p1 p2],{'finger','palm'},'Location','southeast'); %凡例

%Figure ファイルの保存
output_figname = sprintf('%s_TPD',subject_name);
saveas(figure1,output_figname,'fig');


%座標を求める
function [x1, x2, y1, y2] = find_plot(stim_x, yfit, par) %[出力する変数]=関数名(入力する変数)
    x1 = 0;
    y1 = 0;
    for i = 1:numel(stim_x) %numelは配列の要素数
        x = stim_x(i);
        y = yfit(i) * 10;
        if y < par 
            x1 = max(x1,x); %yが50より小さいときの最大のx,yをx1,y1に代入
            y1 = max(y1,y); 
            x2 = stim_x(i+1); %x1,y1の次の点の座標をx2,y2に代入
            y2 = yfit(i+1) * 10;
        end 
    end
end

%y=ax+bに当てはめて閾値を計算
function X = calc_threshold(x1, x2, y1, y2, par)
    a = (y2 - y1) / (x2 - x1);
    b = y1 - a * x1;
    X = (par - b) / a;
end