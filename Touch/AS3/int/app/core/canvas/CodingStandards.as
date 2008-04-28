Package:
	All lowercase naming. 
	Corresponds to directory organization.
	
Classes:
	Pascal Case: ClassName. No leading underscores.
				 Nouns preferred. Avoid abbreviations.
	
Functions:
	Camel Case: functionName. No leading underscores.
				 Nouns preferred. Avoid abbreviations.
	
Variables:
	Camel Case: variableName. No leading underscores.
				Nouns preferred. Avoid abbreviations.

Single Line Comments:
	Comment characters are in line with adjacent code.
	Use for up to two or three lines, where necessary.
	
Block Comments:
	Comment characters are in line with adjacent code.
	
Brackets and Spacing:
	Brackets each get their own line, except in the case
	of in-line, brief function definitions.
	Spaces are present between all keywords, including
	commas. The exception is in function calls, where
	parentheses' spaces are not required.
				
				
				
The following is an example of correctly-formatted code:

package app.core.canvas
{
	public class NewClass
	{
		function Function(type:parameterVariable):void
		{
			// I am a single line comment.
			// I am in line with adjacent code.
			
			private var newVariable = parameterVariable;
			public var anotherVariable = 5;

			anotherVariable.printZebra(function(){trace("Zebra");});

			/* I am a block comment.
			I am unused code.
			I am in line with adjacent code.
			*/
		}
	}
}