%% Animation

figure(1); hold on
for index = 1:NumberOfCycles-6
    subplot(2,1,1)
    pcolor(flipud(Matrix(:,:,index)))
    title(index+NumberOfCycles(1))
    subplot(2,1,2)
    pcolor(flipud(MatrixSmoothed(:,:,index))) 
    title('Smoothing, 60 days')
    pause(0.2);     
end


%% Animation 2

for index = 1:NumberOfCycles %NumberOfCycles
    pcolor(flipud(Matrix(:,:,index)))
    title(index+NumberOfCycles(1))
    % Store the frame
    pause(0.1)
    M(index)=getframe(gcf); % leaving gcf out crops the frame in the movie.
end

movie2avi(M,'Results/Animations/WaveMovie.avi','compression', 'none');
%% Animation 3

figure(1)
filename = 'Results/Animations/SSH.gif';
for n = 1:NumberOfCycles 
      pcolor(flipud(Matrix(:,:,n)))
      title(n+NumberOfCycles(1))
      pause(0.2)
      drawnow
      frame = getframe(1);
      im = frame2im(frame);
      [imind,cm] = rgb2ind(im,256);
      if n == 1;
          imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
      else
          imwrite(imind,cm,filename,'gif','WriteMode','append');
      end
end
