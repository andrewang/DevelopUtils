//
// fileName
// projectName
//
// Created by programmerName on createTime.
// Copyright (c) copyrightYear programmerName. All rights reserved.
//

#include "TemplateClass.h"

TemplateClass::TemplateClass(void){}

TemplateClass::~TemplateClass(void){}

bool TemplateClass::init()
{
	// super
	if(^!Node::init()){ return false; }

	return true;
}


