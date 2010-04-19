package com.lowereast.guiceymongo.data.generator;

import java.io.IOException;

import com.lowereast.guiceymongo.data.property.UserTypeProperty;
import com.lowereast.guiceymongo.data.type.UserType;

public class UserTypePropertyGenerator extends PropertyGenerator<UserType, UserTypeProperty> {
	public UserTypePropertyGenerator(TypeRegistry typeRegistry) {
		super(UserType.class, typeRegistry);
	}
	
	@Override
	public void createKey(Appendable builder, UserTypeProperty property, int indentCount) throws IOException {
		appendIndent(builder, indentCount).append("public static final String ").append(property.getKeyName()).append(" = \"").append(property.getKeyValue()).append("\";\n");
	}
	
	@Override
	public void createReadable(Appendable builder, UserTypeProperty property, int indentCount) throws IOException {
		UserType type = property.getType();
		
		// has
		appendIndent(builder, indentCount).append("public boolean has").append(property.getCamelCaseName()).append("() {\n");
		appendIndent(builder, indentCount + 1).append("return super.hasField(").append(property.getCamelCaseName()).append("Key);\n");
		appendIndent(builder, indentCount).append("}\n");
		
		// get
		appendIndent(builder, indentCount).append("protected ").append(type.getCanonicalJavaType()).append(" ").append(property.getMemberVariableName()).append(" = null;\n");
		appendIndent(builder, indentCount).append("public ").append(type.getCanonicalJavaType()).append(" get").append(property.getCamelCaseName()).append("() {\n");
		appendIndent(builder, indentCount + 1).append("if (").append(property.getMemberVariableName()).append(" == null) {\n");
		appendIndent(builder, indentCount + 2).append("Object value = super.getField(").append(property.getKeyName()).append(");\n");
		appendIndent(builder, indentCount + 2).append("if (value != null && value instanceof DBObject)\n");
		appendIndent(builder, indentCount + 3).append("").append(property.getMemberVariableName()).append(" = ").append(type.getCanonicalJavaType()).append(".wrap((DBObject)value);\n");
		appendIndent(builder, indentCount + 1).append("}\n");
		appendIndent(builder, indentCount + 1).append("return ").append(property.getMemberVariableName()).append(";\n");
		appendIndent(builder, indentCount).append("}\n");
	}
	
	@Override
	public void createBuilder(Appendable builder, UserTypeProperty property, int indentCount) throws IOException {
		// TODO Auto-generated method stub
		
	}
}
