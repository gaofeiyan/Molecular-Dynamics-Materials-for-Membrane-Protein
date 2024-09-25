# Molecular-Dynamics-Materials
## MD-Step
gmx grompp -f step6.0_minimization.mdp -c step5_input.gro -r step5_input.gro -p topol.top -o em.tpr
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
nohup gmx mdrun -s md3.tpr -cpi md3.cpt -deffnm md3 -nb gpu -v & 
