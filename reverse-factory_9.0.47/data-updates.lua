-- Create the solid fluids during this step because earlier is better?
-- pymods breaks with this because it generates recipes during final-fixes for some reason
if not mods["pypostprocessing"] then
	require("prototypes.solid-fluids")
end
-- Update the values for reverse factory technologies and recipes
require("prototypes.reverse-factory-updates")