import 'dart:convert';

import 'package:chainmore/models/certify_rule.dart';
import 'package:chainmore/models/domain.dart';
import 'package:chainmore/network/apis.dart';
import 'package:flutter/material.dart';
import 'package:chainmore/application.dart';

class CertifyModel with ChangeNotifier {
  List<CertifyRule> _rules;
  Domain _domain;

  Domain get domain => _domain;
  List<CertifyRule> get rules => _rules;

  initState() {
    if (Application.sp.containsKey('certify_state')) {
      var state = json.decode(Application.sp.getString('certify_state'));
      _rules = List<CertifyRule>.from(state['rules'].map((item) => CertifyRule.fromJson(item)));
      _domain = Domain.fromJson(state['domain']);
    }
  }

  certify(BuildContext context) async {
    var data = {
      "domain" : _domain.id,
      "rules" : {}
    };

    var rules = {};

    for (int i = 0; i < _rules.length; ++i) {
      if (_rules[i].type == "choiceproblem") {
        var cps = _rules[i].choiceproblems;
        var problems = [];
        for (int j = 0; j < cps.length; ++ j) {
          var problem = {
            "id" : cps[j].id,
            "answer" : cps[j].selectedChoices,
          };
          problems.add(problem);
        }
        rules[_rules[i].id.toString()] = {
          "type" : _rules[i].type,
          "choiceproblems" : problems,
        };
      }
    }

    data["rules"] = rules;

    print(data);

    var response = await API.postCertify(context, data: data);
    if (response != null && response.data["code"] == 20000) {
      return true;
    }
    return false;
  }

  setChoiceProblem(int ruleId, int problemId, List<int> choices) {
    for (int i = 0; i < _rules.length; ++i) {
      if (_rules[i].id == ruleId) {
        var cps = _rules[i].choiceproblems;
        for (int j = 0; j < cps.length; ++ j) {
          if (cps[j].id == problemId) {
            cps[j].selectedChoices = choices;
            break;
          }
        }
      }
    }
  }

  getChoiceProblem(int ruleId, int problemId) {
    for (int i = 0; i < _rules.length; ++i) {
      if (_rules[i].id == ruleId) {
        var cps = _rules[i].choiceproblems;
        for (int j = 0; j < cps.length; ++ j) {
          if (cps[j].id == problemId) {
            return cps[j].selectedChoices;
          }
        }
      }
    }
    return List<int>();
  }

  setRules(List<CertifyRule> rules) {
    _rules = rules;
  }

  setDomain(Domain domain) {
    _domain = domain;
  }

  hasRules() {
    return _rules != null;
  }

  reset() {
    _rules = null;
    _domain = null;
    deleteState();
  }

  saveState() {
    var state = {
      "rules" : _rules,
      "domain" : _domain,
    };

    Application.sp.setString('certify_state', json.encode(state));
  }

  deleteState() {
    Application.sp.remove('certify_state');
  }

}
