package com.springmvc.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.springmvc.domain.Member;

import jakarta.servlet.http.HttpSession;

@Controller
public class MapController {

	@GetMapping("/map")
	public String showMapPage(HttpSession session, Model model) {
		Member mb = (Member)session.getAttribute("mb");
		
		if(mb == null || mb.getDong() == null) {
			String lat =  session.getAttribute("autolat").toString();
			String lng =  session.getAttribute("autolng").toString();
			model.addAttribute("lat",lat);
			model.addAttribute("lng",lng);
		} else {
			String lat =  session.getAttribute("lat").toString();
			String lng =  session.getAttribute("lng").toString();
			model.addAttribute("lat",lat);
			model.addAttribute("lng",lng);
		}
		return "map";
	}
}
