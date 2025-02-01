# Molecular-Dynamics-Materials
## MD-Step
gmx grompp -f step6.0_minimization.mdp -c 4194_PIP30.gro -r step5_input.gro -p topol.top -o em.tpr
gmx mdrun -deffnm em
gmx grompp -f step6.1_equilibration.mdp -c em.gro -r em.gro -p topol.top -o eq1.tpr -n index.ndx
gmx mdrun -deffnm eq1
gmx grompp -f step6.2_equilibration.mdp -c eq1.gro -r eq1.gro -p topol.top -o eq2.tpr -n index.ndx
gmx mdrun -deffnm eq2
gmx grompp -f step6.3_equilibration.mdp -c eq2.gro -r eq2.gro -p topol.top -o eq3.tpr -n index.ndx
gmx mdrun -deffnm eq3
gmx grompp -f step6.4_equilibration.mdp -c eq3.gro -r eq3.gro -p topol.top -o eq4.tpr -n index.ndx
gmx mdrun -deffnm eq4
gmx grompp -f step6.5_equilibration.mdp -c eq4.gro -r eq4.gro -p topol.top -o eq5.tpr -n index.ndx
gmx mdrun -deffnm eq5
gmx grompp -f step6.6_equilibration.mdp -c eq5.gro -r eq5.gro -p topol.top -o eq6.tpr -n index.ndx
gmx mdrun -deffnm eq6
gmx grompp -f step7_production.mdp -o md.tpr -c eq6.gro -p topol.top -n index.ndx
nohup gmx mdrun -deffnm md -pme gpu -nb gpu -bonded gpu -v & 
if interrupted,
nohup gmx mdrun -s md.tpr -cpi md.cpt -deffnm md -nb gpu -v & 
## MD-Analyze
gmx make_ndx -f md.gro -o prolig_center.ndx

  _3 groups: pro_lig lipid pro_lig_lipid_
  
  _check groups : gmx make_ndx -f md.gro -n prolig_center.ndx_

gmx trjconv -s md.tpr -f md.trr -o noPBC_step1.trr -pbc mol -center -n prolig_center.ndx
 
  _select **pro_lig_lipid** and when you want to output all the atoms in this system, just select **system** at the secondary selection)_
### RMSD
gmx rms -f noPBC_step1.trr -s md.tpr -o md-rmsd.xvg -n prolig_center.ndx
  
  _select Backbone group twice._
### extract stable scale following RMSD analysis
gmx trjconv -f noPBC_step1.trr -b 250000 -e 500000 -o analyze.xtc 
### RMSF
gmx rmsf -f analyze.xtc  -s md.tpr -o rmsf.xvg -res -n prolig_center.ndx

_select Backbone group._
### Rg
gmx gyrate -s md.tpr -f noPBC_step1.trr -o md-gyrate.xvg -n prolig_center.ndx

  _select Backbone group._
### SASA
gmx sasa -f noPBC_step1.trr -s md.tpr -o md-area.xvg -n prolig_center.ndx

_select Backbone group._
### H Bonds
gmx hbond -f noPBC_step1.trr -s md.tpr -n prolig_center.ndx -num hbnum.xvg -hbn hbonds.ndx -hbm hbmap.xpm

_select 1 Protein and 13 UNK_

### PCA
gmx rms -s md.tpr -f noPBC_step1.trr -o FEL_rmsd.xvg -n prolig_center.ndx 

gmx gyrate -s md.tpr -f noPBC_step1.trr -o FEL_gyrate.xvg -n prolig_center.ndx 

pc_combine.py FEL_rmsd.xvg FEL_gyrate.xvg output.xvg (3 lines in order: time, rmsd, rg)

gmx sham -tsham 310 -nlevels 100 -f output.xvg -ls gibbs.xpm -g gibbs.log -lsh enthalpy.xpm -lss entropy.xpm

python xpm2png.py -ip yes -f gibbs.xpm (sources/xpm_show/xpm2png.py)

_check bindex.ndx and gibbs.log to find mini-energy-conformation     

To check the trr: gmx check -f noPBC_step1.trr_

gmx trjconv -s md.tpr -f prolig_fit.xtc -o 4194.pdb -sep -b 4100 -e 4100 -pbc mol -n prolig_center.ndx

extract the best mini-conformation into next new cycles until 3 times at least.

### MM/PBSA
chmod +x gmx_mmpbsa.bash

bash gmx_mmpbsa.bash
