function results = oneD_displacement_Gauss_2popu(traj_array, umperpix, time)

results.traj_results = SingleMolD(traj_array, 1, umperpix, time);

Displ_n = [];
Dx = [];
Dy = [];
D2 = [];
n = 1;
for i = 1: length(results.traj_results)
    Displ_n = cat(1, Displ_n, results.traj_results{i}.Displacements{n});
    Dx = cat (1, Dx, results.traj_results{i}.Dx);
    Dy = cat (1, Dy, results.traj_results{i}.Dy);
    D2 = cat (1, D2, results.traj_results{i}.D2);
end
results.D(n).Displ_n = Displ_n;
results.D(n).Dx = Dx;
results.D(n).Dy = Dy;
results.D(n).D2 = D2;

Displ = results.D(n).Displ_n;
nbins = round(sqrt(length(Displ)));
[results.y, results.x] = hist(Displ, nbins);
results.y = results.y/trapz(results.x, results.y);
results.mu = mean(Displ(:, 1));
results.sigma = std(Displ(:, 1));
results.y_fit = normpdf(results.x, results.mu, results.sigma);
results.y_fit2 = fit(results.x, results.y, 'gauss1');

results.Displ_n_2G = fit(results.x, results.y, 'gauss2', 'StartPoint', [3 0 0.05 3 0 0.1]);
para = coeffvalues(results.Displ_n_2G);

t = 0.00674;

errs = diff(confint(results.Displ_n_2G));
results.errs = errs;
results.p1 = para(1)*para(3)*sqrt(pi);
%results.std_p1 = errs(1)*errs(3)*sqrt(pi);
results.std_p1 = results.p1*sqrt(errs(1)^2+errs(3)^2);
results.D1 = para(3)^2/(4*n*t);
%results.std_D1 = errs(3)^2/(4*n*t);
results.std_D1 = results.D1*2*(errs(3)/para(3));

results.p2 = para(4)*para(6)*sqrt(pi);
%results.std_P2 = errs(4)*errs(6)*sqrt(pi);
results.std_p2 = results.p2*sqrt(errs(4)^2+errs(6)^2);
results.D2 = para(6)^2/(4*n*t);
%results.std_D2 = errs(6)^2/(4*n*t);
results.std_D2 = results.D2*2*(errs(6)/para(6));

results.Displ_1_2G_para = [results.D1 results.p1 results.D2 results.p2];

results.g1 = para(1)*exp(-((results.x-para(2))/para(3)).^2);
results.g2 = para(4)*exp(-((results.x-para(5))/para(6)).^2);
%g3 = para(7)*exp(-((x-para(8))/para(9)).^2);
results.g = results.g1 + results.g2;

results.resid = results.y - results.g;

end